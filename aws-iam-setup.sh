#!/bin/bash

# ============================================================================
# COMPLETE AWS IAM USER MANAGEMENT GUIDE
# ============================================================================

# ============================================================================
# 1. SETTING UP SPECIFIC PERMISSIONS
# ============================================================================

# --- Create a custom policy for S3 access ---
cat > s3-read-write-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::my-bucket-name",
        "arn:aws:s3:::my-bucket-name/*"
      ]
    }
  ]
}
EOF

# Create the policy
aws iam create-policy \
  --policy-name S3ReadWritePolicy \
  --policy-document file://s3-read-write-policy.json

# --- Create a custom EC2 policy ---
cat > ec2-limited-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:RebootInstances"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "ec2:ResourceTag/Environment": "Development"
        }
      }
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name EC2DevelopmentPolicy \
  --policy-document file://ec2-limited-policy.json

# --- Attach custom policy to user ---
aws iam attach-user-policy \
  --user-name john-doe \
  --policy-arn arn:aws:iam::123456789012:policy/S3ReadWritePolicy

# --- Common AWS managed policies ---
# Read-only access
aws iam attach-user-policy \
  --user-name john-doe \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# PowerUser access (everything except IAM)
aws iam attach-user-policy \
  --user-name john-doe \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# Administrator access
aws iam attach-user-policy \
  --user-name john-doe \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# ============================================================================
# 2. CREATING MULTIPLE USERS
# ============================================================================

# --- Create users from a list ---
USERS=("alice" "bob" "charlie" "diana")

for user in "${USERS[@]}"; do
  echo "Creating user: $user"
  aws iam create-user --user-name "$user"
  
  # Create login profile with temporary password
  aws iam create-login-profile \
    --user-name "$user" \
    --password "TempPassword123!" \
    --password-reset-required
  
  # Add to a group
  aws iam add-user-to-group \
    --user-name "$user" \
    --group-name developers
  
  echo "User $user created successfully"
done

# --- Bulk creation from CSV file ---
# CSV format: username,email,department
# alice,alice@company.com,Engineering
# bob,bob@company.com,Marketing

while IFS=',' read -r username email department; do
  # Skip header line
  if [ "$username" != "username" ]; then
    echo "Creating user: $username"
    
    aws iam create-user \
      --user-name "$username" \
      --tags Key=Email,Value="$email" Key=Department,Value="$department"
    
    aws iam create-login-profile \
      --user-name "$username" \
      --password "ChangeMe123!" \
      --password-reset-required
  fi
done < users.csv

# ============================================================================
# 3. SECURITY BEST PRACTICES
# ============================================================================

# --- Set account password policy ---
aws iam update-account-password-policy \
  --minimum-password-length 14 \
  --require-symbols \
  --require-numbers \
  --require-uppercase-characters \
  --require-lowercase-characters \
  --allow-users-to-change-password \
  --max-password-age 90 \
  --password-reuse-prevention 5

# --- Enable MFA for a user (virtual MFA device) ---
# First, create virtual MFA device
aws iam create-virtual-mfa-device \
  --virtual-mfa-device-name john-doe-mfa \
  --outfile /tmp/QRCode.png \
  --bootstrap-method QRCodePNG

# Enable MFA (user needs to scan QR code and provide two consecutive codes)
aws iam enable-mfa-device \
  --user-name john-doe \
  --serial-number arn:aws:iam::123456789012:mfa/john-doe-mfa \
  --authentication-code-1 123456 \
  --authentication-code-2 789012

# --- Require MFA with a policy ---
cat > require-mfa-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllExceptListedIfNoMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
EOF

aws iam put-user-policy \
  --user-name john-doe \
  --policy-name RequireMFA \
  --policy-document file://require-mfa-policy.json

# --- Rotate access keys ---
# List current access keys
aws iam list-access-keys --user-name john-doe

# Create new access key
NEW_KEY=$(aws iam create-access-key --user-name john-doe)
echo "$NEW_KEY"

# After verifying new key works, delete old key
aws iam delete-access-key \
  --user-name john-doe \
  --access-key-id AKIAIOSFODNN7EXAMPLE

# --- Find and deactivate old access keys (older than 90 days) ---
aws iam list-users --query 'Users[*].UserName' --output text | while read username; do
  aws iam list-access-keys --user-name "$username" --query 'AccessKeyMetadata[*].[AccessKeyId,CreateDate]' --output text | while read key_id create_date; do
    key_age=$(( ($(date +%s) - $(date -d "$create_date" +%s)) / 86400 ))
    if [ $key_age -gt 90 ]; then
      echo "Key $key_id for user $username is $key_age days old"
      aws iam update-access-key \
        --user-name "$username" \
        --access-key-id "$key_id" \
        --status Inactive
    fi
  done
done

# ============================================================================
# 4. PROGRAMMATIC ACCESS SETUP
# ============================================================================

# --- Create access keys for programmatic access ---
aws iam create-access-key --user-name john-doe

# Save output to file
aws iam create-access-key --user-name john-doe > john-doe-credentials.json

# --- Set up AWS CLI profile for the new user ---
# After getting access key ID and secret access key:
aws configure --profile john-doe
# Enter Access Key ID, Secret Access Key, region, and output format

# Or configure programmatically
aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE --profile john-doe
aws configure set aws_secret_access_key wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY --profile john-doe
aws configure set region us-east-1 --profile john-doe
aws configure set output json --profile john-doe

# Test the profile
aws sts get-caller-identity --profile john-doe

# --- Create service account for applications ---
SERVICE_ACCOUNT="app-backend-service"

# Create service account (no console access)
aws iam create-user --user-name "$SERVICE_ACCOUNT"

# Attach specific policy
aws iam attach-user-policy \
  --user-name "$SERVICE_ACCOUNT" \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create access key
aws iam create-access-key --user-name "$SERVICE_ACCOUNT" > "${SERVICE_ACCOUNT}-keys.json"

# Tag as service account
aws iam tag-user \
  --user-name "$SERVICE_ACCOUNT" \
  --tags Key=Type,Value=ServiceAccount Key=Application,Value=Backend

# ============================================================================
# 5. ORGANIZATIONAL SETUP
# ============================================================================

# --- Create groups ---
GROUPS=("developers" "qa-team" "devops" "read-only-users" "administrators")

for group in "${GROUPS[@]}"; do
  echo "Creating group: $group"
  aws iam create-group --group-name "$group"
done

# --- Attach policies to groups ---
# Developers group
aws iam attach-group-policy \
  --group-name developers \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# QA team
aws iam attach-group-policy \
  --group-name qa-team \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess

# DevOps team
aws iam attach-group-policy \
  --group-name devops \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# Read-only users
aws iam attach-group-policy \
  --group-name read-only-users \
  --policy-arn arn:aws:iam::aws:policy/ViewOnlyAccess

# --- Create department-based structure ---
# Engineering department policy
cat > engineering-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "s3:*",
        "rds:*",
        "lambda:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": ["us-east-1", "us-west-2"]
        }
      }
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name EngineeringDepartmentPolicy \
  --policy-document file://engineering-policy.json

aws iam attach-group-policy \
  --group-name developers \
  --policy-arn arn:aws:iam::123456789012:policy/EngineeringDepartmentPolicy

# --- Implement RBAC (Role-Based Access Control) ---
# Create roles for different job functions

# Developer role
cat > developer-role-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "cloudwatch:GetMetricStatistics",
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF

aws iam create-policy \
  --policy-name DeveloperRolePolicy \
  --policy-document file://developer-role-policy.json

# --- Complete user setup with group assignment ---
create_complete_user() {
  local username=$1
  local group=$2
  local department=$3
  
  echo "Creating complete user setup for: $username"
  
  # Create user
  aws iam create-user \
    --user-name "$username" \
    --tags Key=Department,Value="$department" Key=ManagedBy,Value=Script
  
  # Create login profile
  aws iam create-login-profile \
    --user-name "$username" \
    --password "TempPass123!" \
    --password-reset-required
  
  # Add to group
  aws iam add-user-to-group \
    --user-name "$username" \
    --group-name "$group"
  
  # Apply MFA requirement
  aws iam put-user-policy \
    --user-name "$username" \
    --policy-name RequireMFA \
    --policy-document file://require-mfa-policy.json
  
  echo "User $username created and added to $group group"
}

# Usage examples
create_complete_user "alice-smith" "developers" "Engineering"
create_complete_user "bob-jones" "qa-team" "QualityAssurance"
create_complete_user "charlie-brown" "devops" "Operations"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

# --- List all users with their groups ---
list_users_with_groups() {
  aws iam list-users --query 'Users[*].UserName' --output text | while read username; do
    echo "User: $username"
    groups=$(aws iam list-groups-for-user --user-name "$username" --query 'Groups[*].GroupName' --output text)
    echo "  Groups: $groups"
  done
}

# --- Audit user permissions ---
audit_user() {
  local username=$1
  echo "=== Audit for user: $username ==="
  
  echo "Groups:"
  aws iam list-groups-for-user --user-name "$username" --query 'Groups[*].GroupName'
  
  echo "Attached policies:"
  aws iam list-attached-user-policies --user-name "$username" --query 'AttachedPolicies[*].PolicyName'
  
  echo "Inline policies:"
  aws iam list-user-policies --user-name "$username" --query 'PolicyNames'
  
  echo "Access keys:"
  aws iam list-access-keys --user-name "$username" --query 'AccessKeyMetadata[*].[AccessKeyId,Status,CreateDate]' --output table
  
  echo "MFA devices:"
  aws iam list-mfa-devices --user-name "$username" --query 'MFADevices[*].[SerialNumber,EnableDate]' --output table
}

# --- Delete user completely ---
delete_user_completely() {
  local username=$1
  echo "Deleting user: $username"
  
  # Remove from all groups
  aws iam list-groups-for-user --user-name "$username" --query 'Groups[*].GroupName' --output text | while read group; do
    aws iam remove-user-from-group --user-name "$username" --group-name "$group"
  done
  
  # Detach all managed policies
  aws iam list-attached-user-policies --user-name "$username" --query 'AttachedPolicies[*].PolicyArn' --output text | while read policy; do
    aws iam detach-user-policy --user-name "$username" --policy-arn "$policy"
  done
  
  # Delete all inline policies
  aws iam list-user-policies --user-name "$username" --query 'PolicyNames' --output text | while read policy; do
    aws iam delete-user-policy --user-name "$username" --policy-name "$policy"
  done
  
  # Delete access keys
  aws iam list-access-keys --user-name "$username" --query 'AccessKeyMetadata[*].AccessKeyId' --output text | while read key; do
    aws iam delete-access-key --user-name "$username" --access-key-id "$key"
  done
  
  # Deactivate and delete MFA devices
  aws iam list-mfa-devices --user-name "$username" --query 'MFADevices[*].SerialNumber' --output text | while read serial; do
    aws iam deactivate-mfa-device --user-name "$username" --serial-number "$serial"
    aws iam delete-virtual-mfa-device --serial-number "$serial"
  done
  
  # Delete login profile
  aws iam delete-login-profile --user-name "$username" 2>/dev/null || true
  
  # Finally, delete the user
  aws iam delete-user --user-name "$username"
  
  echo "User $username deleted completely"
}

# Usage: audit_user john-doe
# Usage: delete_user_completely john-doe