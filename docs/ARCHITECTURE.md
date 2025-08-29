# Architecture Summary (thin-slice)

- ECS Fargate for services (default)
- API Gateway -> SQS -> routing-service (ECS task)
- DynamoDB (entities), RDS (config/audit)
- Cognito for auth (or external IdP)
- EventBridge for domain events, Step Functions for approvals
