# Requires:
-  `brew install aws-elasticbeanstalk`
- Security access id and secret access keys: https://console.aws.amazon.com/iam/

# 221110
- following https://www.youtube.com/watch?v=jYB_IgBhi08
- secret key base is taken from old app
- Logs are on sidebar within environment

# 221111 Troubleshooting:
- change ruby version in gemfile to 3.0.4 bc 3.1 unsupported Nov 2022 https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platform-history-ruby.html
- specify node version 16.14.2 in package.json