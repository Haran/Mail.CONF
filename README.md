# Habrahabr

Repository created for article <http://habrahabr.ru/post/193220/>

# Warning

* Syslog-ng.conf and postfixStat.pl are added for cursory examination only. If you are planning to use'em, review and double check log paths everywhere
* *permit_mynetworks* option is strictly doubtful and potentially very dangerous. Use it with caution, narrow trusted networks or better disable `permit_mynetworks` option at all - let your users send mails only after authentication.

# Mail server configuration

This is a mail server configuration files for:

* Postfix
* Dovecot
* Amavis
* Spamassassin
* ClamAV
* Postgrey
* Fail2ban
* MySQL

# Necessary actions

To get things working don't forget to:

* Install all necessary software
* Change passwords for mysql in all necessary config files
* Register services
* Perform tests
