# Nectar Freshdesk Integration Components Puppet Module

Contains scripts, puppet module, credentials, secrets and other configuration that applies to PIP and OSID Freshdesk integrations.

## Assumptions

- Production and Test servers require an HTTP proxy for outgoing internet connectivity.

## Pre-requisites

- Ubuntu 14.04
- Firewall configuration allowing port 22 and 443
- TLS/SSL certificate
- Hiera configuration

### PIP 

- PIP requires an AAF Unique login URL that is obtained by [registering the service](https://rapid.aaf.edu.au/registration). Please look at [AAF documentation](https://rapid.aaf.edu.au/developers) for more details. Due to the nature of this manual step, installation cannot be fully automated. 
- MongoDB server

### OSID

- OSID requires Openstack login credentials that have cross-project/tenancy access, i.e. 'nova list' and 'nova show'.

## Installation 

Install this Puppet Module

Modify and install your Hiera configuration. Relevant config entries are explained below:

pip_jws_secret: Generate a random value secret for JWS
pip_login_url: Provided by AAF upon service registration.
pip_freshdesk_login_url: Freshdesk SSO Endpoint, refer to Freshdesk Documentation.
pip_freshdesk_key: Freshdesk SSO Key, refer to Freshdesk Documentation.
pip_mongo_host: 
pip_mongo_user: 
pip_mongo_pw: 
pip_mongo_db: 
osid_showinstanceinfo: Openstack command to retrieve instance information, `<instanceId>` will be replaced by ID of the instance
osid_getinstancelist: Openstack command to find the instance using the IP address. `<ipAddress>` will be replaced by the IP from the text body.
osid_freshdesk_host: Freshdesk Domain
osid_freshdesk_user: Freshdesk Username / API Key
osid_basic_auth: Basic Auth value used to secure this API endpoint, will be used at Freshdesk.
osid_http_proxy: HTTP proxy if required
ssl_server_crt: SSL Cert
ssl_server_key: SSL Key
