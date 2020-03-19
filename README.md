# reflex-aws-rds-public-snapshot
Rule that detects when an RDS snapshot is set to be public.

## Usage
To use this rule either add it to your `reflex.yaml` configuration file:  
```
rules:
  - reflex-aws-rds-public-snapshot:
```

or add it directly to your Terraform:  
```
...

module "reflex-aws-rds-public-snapshot" {
  source           = "github.com/cloudmitigator/reflex-aws-rds-public-snapshot"
}

...
```

## License
This Reflex rule is made available under the MPL 2.0 license. For more information view the [LICENSE](https://github.com/cloudmitigator/reflex-aws-rds-public-snapshot/blob/master/LICENSE) 
