# Migration from 0.30.1 to 0.32.x+

NOTE: This is not a migration guide from the pre-release versions 0.31.0 and 0.31.1

Version `0.32.0` of this module introduces changes that, without taking additional precautions, will cause the security group created by this module to be replaced with a new one. Note that the EFS file system will not be affected, all that will change is that the EFS mount targets will be moved to a new security group and there may be a brief period (likely only a few seconds) during which all connectivity is lost. 

This is because of the newer version's reliance on the [terraform-aws-security-group](https://github.com/cloudposse/terraform-aws-security-group)
module for managing the module's security group. This changes the Terraform resource address.

To circumvent this, after bumping the module version to the newer version, make note of these changes.

* `transition_to_ia` is now a `list(string)` so pass in the single value as a list.
* `zone_id` is now a `list(string)` so pass in the single value as a list.
* `kms_key_id` is now a `list(string)` so pass in the single value as a list.
* `security_groups` is deprecated

For more information on why we use a `list(string)` instead of `string` for strings vars, see the SG 4.0 releae notes "Optional Inputs" section linked below.

Run a `terraform plan` to retrieve the resource addresses of the SG that Terraform would like to destroy, and the resource address of the SG which Terraform would like to create.

Make sure that the following variables are set since the original SG name had the suffix `-efs`.

* Setting `security_group_create_before_destroy = false` prevents using `name_prefix` on the SG resource
* Setting `security_group_name` to its "legacy" value will keep the Security Group from being replaced, and hence the underlying resource.

```hcl
security_group_create_before_destroy = false

# if not using context
security_group_name = ["<existing-sg-name>"]

# if using context
security_group_name = ["${module.this.context}-efs"]
```

Finally, change the resource address of the existing Security Group. The resources' source and destination addresses will vary based on how this module is used.

If the module's name is `efs`, here is an example set of `terraform state mv` commands to get started.

```bash
# required - move the security group resource
terraform state mv \
  'module.efs.aws_security_group.efs[0]' \
  'module.efs.module.security_group.aws_security_group.default[0]'
# optional - move the security group rules (may be different depending on usage)
terraform state mv \
  'module.efs.aws_security_group_rule.ingress_security_groups[0]' \
  'module.efs.module.security_group.aws_security_group_rule.keyed["_m[0]#[0]#sg#0"]'
terraform state mv \
  'module.efs.aws_security_group_rule.egress[0]' \
  'module.efs.module.security_group.aws_security_group_rule.keyed["_allow_all_egress_"]'
```

This will result in an plan that will only destroy SG Rules, but not the Security Group itself.

Please run a `terraform plan` to make sure there aren't other unexpected breaking changes.

## References

* https://github.com/cloudposse/terraform-aws-security-group/blob/c6e4156696ee28cad0cd927c82377fbd73156199/exports/security_group_inputs.tf#L71-L72
* https://github.com/cloudposse/terraform-aws-security-group/releases/tag/0.4.0
