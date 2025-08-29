Terraform infra layout (minimal dev env):

infra/
├─ modules/
│  ├─ vpc/
│  ├─ ecs-fargate/
│  └─ dynamodb/
└─ envs/
   └─ dev/
      ├─ backend.tf
      ├─ providers.tf
      └─ main.tf

This scaffold contains minimal, example TF files for local testing only.
