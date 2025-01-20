# Requirements

Some requirements need to be fulfilled before you can apply the zitadel-admin TF configuration:

- [Setup the zitadel external domain](https://zitadel.com/docs/self-hosting/manage/custom-domain#changing-externaldomain-externalport-or-externalsecure)
- Update the password for the default admin user: zitadel-admin@zitadel.localhost
- Create a service user with a JWT token
- The domain and the JWT will be used the setup the Zitadel provider.
  - They are Expected to be set on zitadel_doamin and zitadel_jwt variables
