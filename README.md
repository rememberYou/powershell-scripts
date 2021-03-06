![Powershell logo](Assets/Powershell_black_64.png "Powershell logo") PowerShell Scripts
===============================

Useful PowerShell scripts to configure a basic Windows Server 2016. The purpose
of this repository is to have a little working configuration that can be used to
set up your own server.

Feel free to use the code for your own purposes and contribute to this repository if
you notice any mistakes.

--------------------

### Supported roles and features [9/11] ###

- [x] AD (with ADRecycleBin)
- [x] Backups
- [x] Basic Firewall
- [x] Basic IPv4 and IPv6
- [ ] Certificates
    - [ ] Authority-Signed
    - [x] Self-Signed
- [x] DHCPv4 and DHCPv6
- [x] DNSv4 and DNSv6
- [ ] GPO
- [x] Shadow Copies
- [x] Share
    - [x] File screen
    - [x] Permissions
    - [x] Quotas
    - [x] Scheme
- [x] Time Zone

--------------------

### Usage ###

After installing a Windows server, execute scripts according to the desired
services to install.

Before use any script, specify the new execution policy to avoid errors related
to script signatures.

	PS> Set-ExecutionPolicy Bypass

Be careful that the scripts are made for Windows Server 2016 and may not work
for earlier version.

Also, always check the examples in the scripts to know the syntax to use for the
configuration.

Example for installing DHCP Server Role with Windows PowerShell:

	PS> git clone git@github.com:rememberYou/powershell-scripts.git
	PS> cd powershell-scripts/DHCP/
	PS> .\Conf-DHCP.ps1 -StartRangeV4 192.168.1.2 -EndRangeV4 192.168.2.254 `
                            -ScopeIDV4 192.168.1.0 -SubnetMaskV4 255.255.0.0 `
                            -DnsServer 192.168.42.1 -ComputerName 'SRVDNSPrimary' `
                            -DnsDomain 'heh.lan' -PrefixV6 2001:db8:cafe:10::1 `
                            -LifeTime 2.00:00:00

After setting up the scripts, turn back the execution policy to `AllSigned` if
you have set up the possibility for users to sign their scripts (or
`Restricted`).

	PS> Set-ExecutionPolicy AllSigned
	
--------------------

### License ###

Code is under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl.html)
