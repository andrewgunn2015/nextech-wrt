<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<script type='text/javascript'>

//	<% nvram("ddnsx0,ddnsx1,ddnsx_ip,wan_dns,wan_get_dns,dns_addget"); %>
//	<% ddnsx(); %>

/* REMOVE-BEGIN

t = hostname (top)
u = username/password
h = hostname
j = hostname (optional)
c = custom url
w = wildcard
m = MX
b = backup MX
o = use OpenDNS
a = freedns.afraid
z = can't use client-given IP address

REMOVE-END */

var services = [
	['', 'None', '', ''],
	['3322', '3322', 'http://www.3322.org/', 'uhwmb'],
	['3322-static', '3322 - Static', 'http://www.3322.org/', 'uhwmb'],
	['dnsexit', 'DNS Exit', 'http://www.dnsexit.com/', 'uh'],
	['dnsomatic', 'DNS-O-Matic', 'http://www.dnsomatic.com/', 'u'],
	['dyndns', 'DynDNS - Dynamic', 'http://www.dyndns.com/', 'uhwmb'],
	['dyndns-static', 'DynDNS - Static', 'http://www.dyndns.com/', 'uhwmb'],
	['dyndns-custom', 'DynDNS - Custom', 'http://www.dyndns.com/', 'uhwmb'],
	['sdyndns', 'DynDNS (https) - Dynamic', 'http://www.dyndns.com/', 'uhwmb'],
	['sdyndns-static', 'DynDNS (https) - Static', 'http://www.dyndns.com/', 'uhwmb'],
	['sdyndns-custom', 'DynDNS (https) - Custom', 'http://www.dyndns.com/', 'uhwmb'],
	['dyns', 'DyNS', 'http://www.dyns.cx/', 'uh'],
	['easydns', 'easyDNS', 'http://www.easydns.com/', 'uhwm'],
	['seasydns', 'easyDNS (https)', 'http://www.easydns.com/', 'uhwm'],
	['everydns', 'EveryDNS', 'http://www.everydns.net/', 'uj', null, null, 'Domain <small>(optional)</small>'],
	['enom', 'eNom', 'http://www.enom.com/', 'ut', 'Domain'],
	['afraid', 'FreeDNS (afraid.org)', 'http://freedns.afraid.org/', 'az'],
	['ieserver', 'ieServer.net', 'http://www.ieserver.net/', 'uhz', 'Username / Hostname', null, 'Domain'],
	['namecheap', 'namecheap', 'http://www.namecheap.com/', 'ut', 'Domain'],
	['noip', 'No-IP.com', 'http://www.no-ip.com/', 'uh', 'Email Address', null, 'Hostname / Group'],
	['opendns', 'OpenDNS', 'http://www.opendns.com/', 'uhoz', null, null, 'Network <small>(optional)</small>'],
	['tzo', 'TZO', 'http://www.tzo.com/', 'uh', 'Email Address', 'Password'],
	['zoneedit', 'ZoneEdit', 'http://www.zoneedit.com/', 'uh'],
	['custom', 'Custom URL', '', 'c']];

var opendns = ['208.67.222.222', '208.67.220.220'];
var opendnsInUse = 0;

function msgLoc(s)
{
	var r;

	s = s.replace(/\n+/g, ' ');
	if (r = s.match(/^(.*?): (.*)/)) {
		r[2] = r[2].replace(/#RETRY (\d+) (\d+)/,
			function(s, min, num) {
				return '<br><small>(' + ((num >= 1) ? (num + '/3: ') : '') + 'Automatically retrying in ' + min + ' minutes)</small>';
			}
		);
		return '<small>' + (new Date(r[1])).toLocaleString() + ':</small><br>' + r[2];
	}
	else if (s.length == 0) {
		return '-';
	}
	return s;
}

function mop(s)
{
	var op, i;
	
	op = {};
	for (i = s.length - 1; i >= 0; --i) {
		op[s.charAt(i)] = 1;
	}
	
	return op;
}

function verifyFields(focused, quiet)
{
	var i;
	var data, r, e;
	var op;
	var enabled;
	var b;
	
	b = E('_f_ddnsx_ip').value == 'custom';
	elem.display(PR('_f_custom_ip'), b);
	if ((b) && (!v_ip('_f_custom_ip', quiet))) return 0;
	
	r = 1;
	for (i = 0; i < 2; ++i) {
		data = services[E('_f_service' + i).selectedIndex] || services[0];
		enabled = (data[0] != '');
	
		op = mop(data[3]);

		elem.display(PR('url' + i), (enabled) && (data[0] != 'custom'));
		elem.display('row_z' + i, op.z);

		elem.display(PR('_f_hosttop' + i), op.t);
		elem.display(PR('_f_user' + i), PR('_f_pass' + i), op.u);
		elem.display(PR('_f_host' + i), op.h || op.j);
		elem.display(PR('_f_cust' + i), 'custmsg' + i, op.c);
		
		elem.display(PR('_f_wild' + i), op.w);
		elem.display(PR('_f_mx' + i), op.m);
		elem.display(PR('_f_bmx' + i), op.b);
		elem.display(PR('_f_opendns' + i), op.o);
		elem.display(PR('_f_afraid' + i), op.a);
		
		elem.display(PR('_f_force' + i), 'last-response' + i, enabled);
		elem.display('last-update' + i, enabled && !op.z);

		if (enabled) {
			PR('_f_user' + i).cells[0].innerHTML = data[4] || 'Username';
			PR('_f_pass' + i).cells[0].innerHTML = data[5] || 'Password';
			PR('_f_host' + i).cells[0].innerHTML = data[6] || 'Hostname';

			e = E('url' + i);
			e.href = data[2];
			e.innerHTML = data[2];

			if (op.c) {
				e = E('_f_cust' + i);
				e.value = e.value.trim();
				if (e.value == '') {
					e.value = 'http://';
				}
				if (e.value.search(/http(s?):\/\/./) != 0)  {
					ferror.set(e, 'Expecting a URL -- http://... or https://...', quiet)
					r = 0;
				}
				else {
					ferror.clear(e);
				}
			}
			else if (op.a) {
				e = E('_f_afraid' + i);
				e.value = e.value.trim();
				if (e.value.match(/freedns\.afraid\.org\/dynamic\/update\.php\?([a-zA-Z0-9]+)/)) {
					e.value = RegExp.$1;
				}
				if (e.value.search(/^[A-Za-z0-9]+/) == -1) {
					ferror.set(e, 'Invalid hash or URL', quiet)
					r = 0;
				}
				else {
					ferror.clear(e);
				}
			}
			else {
				if ((!v_length('_f_user' + i, quiet, 1)) ||
					(!v_length('_f_pass' + i, quiet, 1)) ||
					((op.h) && (!op.o) && (!v_length('_f_host' + i, quiet, 1))) ||
					((op.t) && (!v_length('_f_hosttop' + i, quiet, 1)))) {
					r = 0;
				}
			}
		}
	}
	
	// shouldn't do this twice, but...
	if (E('_f_opendns0') == focused) E('_f_opendns1').checked = E('_f_opendns0').checked;
	if (E('_f_opendns1') == focused) E('_f_opendns0').checked = E('_f_opendns1').checked;
	
	return r;
}

function save()
{
	var fom;
	var i, j, s;
	var data, a, b;
	var setopendns;
	var op;
	
	if (!verifyFields(null, 0)) return;

	fom = E('_fom')
	
	fom.ddnsx_ip.value = (E('_f_ddnsx_ip').value == 'custom') ? E('_f_custom_ip').value : E('_f_ddnsx_ip').value;
	
	setopendns = -1;
	for (i = 0; i < 2; ++i) {
		s = [];
		data = services[E('_f_service' + i).selectedIndex] || services[0];
		s.push(data[0]);
		if (data[0] != '') {
/* REMOVE-BEGIN

t = hostname (top)
u = username/password
h = hostname
c = custom url
w = wildcard
m = MX
b = backup MX
o = use OpenDNS
a = freedns.afraid
z = can't use client-given IP address

*/
		
/*

	username:password<
	hostname<
	wildcard<
	mx<
	backup mx<
	custom url/afraid hash<

REMOVE-END */
			op = mop(data[3]);

			if (op.u) s.push(E('_f_user' + i).value + ':' + E('_f_pass' + i).value);
				else s.push('');				

			if (op.t) {
				s.push(E('_f_hosttop' + i).value);
			}
			else if ((op.h) || (op.j)) {
				s.push(E('_f_host' + i).value);
			}
			else {
				s.push('');					
			}

			if (op.w) s.push(E('_f_wild' + i).checked ? 1 : 0);
				else s.push('');
			if (op.m) s.push(E('_f_mx' + i).value)
				else s.push('');
			if (op.b) s.push(E('_f_bmx' + i).checked ? 1 : 0);
				else s.push('');

			if (op.c) {
				s.push(E('_f_cust' + i).value);
			}
			else if (op.a) {
				s.push(E('_f_afraid' + i).value);
			}
			else {
				s.push('');
			}

			if (data[0] == 'opendns') setopendns = E('_f_opendns' + i).checked;
		}
		s = s.join('<');
		fom['ddnsx' + i].value = s;
		fom['ddnsx' + i + '_cache'].disabled = (!E('_f_force' + i).checked) && (s == nvram['ddnsx' + i]);
	}

	if (setopendns != -1) {
		if (setopendns) {
			if (opendnsInUse != opendns.length) {
				fom.wan_dns.value = opendns.join(' ');
				fom.wan_dns.disabled = 0;
				fom._service.value += ',dns-restart';
			}
		}
		else {
			// not set if partial, do not remove if partial
			if (opendnsInUse == opendns.length) {
				a = nvram.wan_dns.split(/\s+/);
				b = [];
				for (i = a.length - 1; i >= 0; --i) {
					for (j = opendns.length - 1; j >= 0; --j) {
						if (a[i] == opendns[j]) {
							a.splice(i, 1);
							break;
						}
					}
				}
				fom.wan_dns.value = a.join(' ');
				fom.wan_dns.disabled = 0;
				fom._service.value += ',dns-restart';
			}
		}
	}
	
	form.submit(fom);
}

function init()
{
	if ('<% psup("ddns-update"); %>' != 0) {
		var e = E('footer-msg');
		e.innerHTML = 'DDNS update is running. Please refresh after a few seconds.';
		e.style.visibility = 'visible';
	}
}
</script>
<body onLoad="init()" style="WIDTH: 100%; HEIGHT: 100%" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0">
<script language="javascript">
{  
	function ChangeLink(obj,state,imgname)  {    
		var img = document.getElementById(imgname);    
		obj.style.color = '#FFFFFF';    
		img.src ='HeaderButtonOff.gif';    
		if(state=='over')    {      
			obj.style.color = '#FDCA17';      
			img.src ='HeaderButtonOver.gif';    
		}  
	}
}
</script>
<table style="WIDTH: 100%; HEIGHT: 100%" cellSpacing="0" cellPadding="0" border="0">
  <tr id="HeaderRow">
    <td><table id="Header_MainMenuMiddle" cellspacing="0" cellpadding="0" border="0" height="120" width="100%" background="HeaderMiddle.gif">
        <tr>
          <td nowrap="nowrap" align="Left" valign="Top" colspan="2"><table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td valign="top"><a id="Header_SiteLogo" href="Default.aspx"><img src="SiteLogo.gif" alt="" border="0" /></a></td>
              </tr>
              <tr>
                <td valign="top"><a id="Header_Hyperlink1" href="Default.aspx"><img src="SiteLogo2.gif" alt="" border="0" /></a></td>
              </tr>
              <tr>
                <td valign="top"><a id="Header_Hyperlink2" href="Default.aspx"><img src="SiteLogo3.gif" alt="" border="0" /></a></td>
              </tr>
            </table></td>
          <td nowrap="nowrap" align="Right" valign="Top" height="120"><div align="right"> <img id="Header_HeaderPixTop" src="HeaderPix.gif" alt="" align="Top" border="0" /><br>
         
	<a id="Header_hlContact" onMouseOver="ChangeLink(this,'over','Header_imgContact');" onMouseOut="ChangeLink(this,'off','Header_imgContact');" href="http://www.nex-tech.com/Document.aspx?mode=1&amp;id=2204" target="_blank"><font color="White" size="1"><img id="Header_imgContact" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Contact Us&nbsp;</font></a>
	<a id="Header_hlEmployment" onMouseOver="ChangeLink(this,'over','Header_imgSpeed');" onMouseOut="ChangeLink(this,'off','Header_imgSpeed');" href="http://speedtest.nex-tech.com/" target="_blank"><font color="White" size="1"><img id="Header_imgSpeed" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Speed Test&nbsp;</font></a>
	<a id="Header_hlEmployment" onMouseOver="ChangeLink(this,'over','Header_imgEmploy');" onMouseOut="ChangeLink(this,'off','Header_imgEmploy');" href="tech-support.asp" target="_blank"><font color="White" size="1"><img id="Header_imgEmploy" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Tech Support&nbsp;&nbsp;</font></a>
 </div></td>
        </tr>
      </table></td>
  </tr>
  <tr height="100%">
    <td style="WIDTH: 100%; HEIGHT: 100%" vAlign="top"><table id="ContentTable" cellspacing="0" cellpadding="0" border="0" height="100%">
        <tr id="ContentRow">
          <td id="ContentLeftCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%; background-color: #3A362B;"><div id="LeftColumn">
              <table id="DefaultLeftColumn_Table1" class="LeftColumn" cellspacing="0" cellpadding="0" border="0" style="WIDTH: 166px; HEIGHT: 100%">
                <tr id="DefaultLeftColumn_TableRow3">
                  <td id="DefaultLeftColumn_TableCell3" style="WIDTH: 166px; HEIGHT: 10px"></td>
                </tr>
                <tr id="DefaultLeftColumn_TableRow1">
                  <td id="DefaultLeftColumn_TableCell1" align="Center" valign="Top" style="WIDTH: 166px; HEIGHT: 100%"><table cellspacing=0 cellpadding=0>
                      <tr>
                        <td valign=top><span id="DefaultLeftColumn_MainMenu">
                          
                          <table cellpadding="0" cellspacing="0" border="0" width="156px" align="center"
  onmouseover="javascript:StopSlideShow();" onMouseOut="javascript:StartSlideShow();">
                            <tr>
                              <td><img id="DefaultLeftColumn_MainMenu__ctl0_SiteSearchHeader" src="SiteSearchHeaderOff.gif" alt="" border="0" /></td>
                            </tr>
                            <tr>
                              <td id="navi" align="left" class="ToolBox"><!-- this fixed the Navigator width problem, was set to align="center"  -->
                                
                                <script type='text/javascript'>navi()</script>
                                
                              </td>
                            </tr>
                            <tr>
                              <td><img id="DefaultLeftColumn_MainMenu__ctl0_SiteSearchFooter" src="ToolBoxFooterOff.gif" alt="" border="0" /></td>
                            </tr>
                          </table>
                          <br />
                          </span></td>
                      </tr>
                    </table>
                    <span> <br />
                    <br />
                    </span></td>
                </tr>
                <tr id="DefaultLeftColumn_TableRow2">
                  <td id="DefaultLeftColumn_TableCell2" align="Center" valign="Middle" style="WIDTH: 166px; HEIGHT: 100%"></td>
                </tr>
              </table>
            </div></td>
          <td id="ContentCenterCell" valign="Top" style="WIDTH: 100%; HEIGHT: 100%"><div id="divBC" style="LEFT: 171px; POSITION: absolute; TOP: 105px"> <span id="breadcrumb"> <br>
              <table id="breadcrumb__ctl0_panel1" onMouseOver="javascript:HidePanel2();" onMouseOut="javascript:ShowPanel2();" nowrap="nowrap" cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td></td>
                </tr>
              </table>
              <table id="breadcrumb__ctl0_panel2" nowrap="nowrap" cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td></td>
                </tr>
              </table>
              
              </span> </div>
            <table id="Content_Content" cellpadding="0" cellspacing="0" border="0" width="100%">
              <tr>
                <td><table width="90%">
                    <tr>
                      <td valign="top" align="left" style="padding-left: 10px;">
						<form id='_fom' method='post' action='tomato.cgi'>
                        
                        <!-- / / / -->
                        
                        <input type='hidden' name='_nextpage' value='basic-ddns.asp'>
                        <input type='hidden' name='_service' value='ddns-restart'>
                        <input type='hidden' name='_nextwait' value='8'>
                        
                        <input type='hidden' name='ddnsx0' value=''>
                        <input type='hidden' name='ddnsx1' value=''>
                        <input type='hidden' name='ddnsx0_cache' value='' disabled>
                        <input type='hidden' name='ddnsx1_cache' value='' disabled>
                        <input type='hidden' name='wan_dns' value='' disabled>
                        <input type='hidden' name='ddnsx_ip' value=''>
                        
                        
                        <div class='section-title'>Dynamic DNS</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        s = nvram.ddnsx_ip;
                        a = (s != '') && (s.indexOf('@') != 0) && (s != '0.0.0.0') && (s != '1.1.1.1') && (s != '10.1.1.1');
                        createFieldTable('', [
                            { title: 'IP Address', name: 'f_ddnsx_ip', type: 'select',
                                options: [
                                    ['', 'Use WAN IP Address ' + ddnsx_ip + ' (recommended)'],
                                    ['@', 'Use External IP Address Checker (every 10 minutes)'],
                                    ['0.0.0.0', 'Offline (0.0.0.0)'],
                                    ['1.1.1.1', 'Offline (1.1.1.1)'],
                                    ['10.1.1.1', 'Offline (10.1.1.1)'],
                                    ['custom', 'Custom IP Address...']
                                    ],
                                value: a ? 'custom' : nvram.ddnsx_ip },
                            { title: 'Custom IP Address', indent: 2, name: 'f_custom_ip', type: 'text', maxlen: 15, size: 20,
                                value: a ? nvram.ddnsx_ip : '', hidden: !a },
                        ]);
                        </script>
                        </div>
                        
                        
                        <script type='text/javascript'>
                        a = nvram.wan_dns.split(/\s+/);
                        for (i = 0; i < a.length; ++i) {
                            for (j = 0; j < opendns.length; ++j) {
                                if (a[i] == opendns[j]) ++opendnsInUse;
                            }
                        }
                        
                        if (nvram.dns_addget == 1) {
                            dns = nvram.wan_dns + ' ' + nvram.wan_get_dns;
                        }
                        else if (nvram.wan_dns != '') {
                            dns = nvram.wan_dns;
                        }
                        else {
                            dns = nvram.wan_get_dns;
                        }
                        dns = dns.split(/\s+/);
                        for (i = 0; i < dns.length; ++i) {
                            for (j = 0; j < opendns.length; ++j) {
                                if (dns[i] == opendns[j]) {
                                    dns[i] = '<i>' + dns[i] + '</i>';
                                    break;
                                }
                            }
                        }
                        dns = dns.join(', ');
                        
                        for (i = 0; i < 2; ++i) {
                            v = nvram['ddnsx' + i].split('<');
                            if (v.length != 7) v = ['', '', '', 0, '', 0, ''];
                            
                            u = v[1].split(':');
                            if (u.length != 2) u = ['', ''];
                            h = (v[0] == '');
                        
                            W('<div class="section-title">Dynamic DNS ' + (i + 1) + '</div><div class="section">');
                            createFieldTable('', [
                                { title: 'Service', name: 'f_service' + i, type: 'select', options: services, value: v[0] },
                                { title: 'URL', indent: 2, text: '<a href="" id="url' + i + '" target="tomato-ext-ddns"></a>', hidden: 1 },
                                { title: '&nbsp;', text: '<small>* This service determines the IP address using its own method.</small>', hidden: 1, rid: 'row_z' + i },
                                { title: 'Hostname', name: 'f_hosttop' + i, type: 'text', maxlen: 96, size: 35, value: v[2], hidden: 1 },
                                { title: 'Username', name: 'f_user' + i, type: 'text', maxlen: 64, size: 35, value: u[0], hidden: 1 },
                                { title: 'Password', name: 'f_pass' + i, type: 'password', maxlen: 64, size: 35, value: u[1], hidden: 1 },
                                { title: 'Hostname', name: 'f_host' + i, type: 'text', maxlen: 255, size: 80, value: v[2], hidden: 1 },
                                { title: 'URL', name: 'f_cust' + i, type: 'text', maxlen: 255, size: 80, value: v[6], hidden: 1 },
                                { title: ' ', text: '(Use @IP for the current IP address)', rid: ('custmsg' + i), hidden: 1 },
                                { title: 'Wildcard', indent: 2, name: 'f_wild' + i, type: 'checkbox', value: v[3] != '0', hidden: 1 },
                                { title: 'MX', name: 'f_mx' + i, type: 'text', maxlen: 32, size: 35, value: v[4], hidden: 1 },
                                { title: 'Backup MX', indent: 2, name: 'f_bmx' + i, type: 'checkbox', value: v[5] != '0', hidden: 1 },
                                { title: 'Use as DNS', name: 'f_opendns' + i, type: 'checkbox', value: (opendnsInUse == opendns.length),
                                    suffix: '<br><small>(Current DNS: ' + dns  + ')</small>', hidden: 1 },
                                { title: 'Token / URL', name: 'f_afraid' + i, type: 'text', maxlen: 255, size: 80, value: v[6], hidden: 1 },
                                { title: 'Force Next Update', name: 'f_force' + i, type: 'checkbox', value: 0, hidden: 1 },
                                null,
                                { title: 'Last IP Address', custom: msgLoc(ddnsx_last[i]), rid: 'last-update' + i, hidden: 1 },
                                { title: 'Last Result', custom: msgLoc(ddnsx_msg[i]), rid: 'last-response' + i, hidden: h }
                            ]);
                            W('</div>');
                        }
                        </script>
                        
                        
                        <!-- / / / -->
                      
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
                        <script type='text/javascript'>verifyFields(null, 1);</script>		
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
            <p id="f_ddnsx_ip" style="display:none"> Dynamic Address For DNS Server, using default is recommended for easy setup.</p>	
            <p id="f_service" style="display:none"> Select the DNS service you wish to use. </p>
          </div></td>
        </tr>
      </table></td>
  </tr>
  <tr id="FooterRow">
  
  <td>
  
  <table cellpadding="0" cellspacing="0" border="0" width="100%" height="66" class="Footer" >
    <tbody>
      <tr >
        <td valign=top nowrap><a id="Footer_hlFooter1" href="http://www.ruraltelephone.com"><img src="FooterLogo1.gif" alt="" border="0" /></a> <a id="Footer_hlFooter2" onClick="window.open('','NewPopUpWindow','directories=no,height=600,width=800,location=no,resizable=yes,scrollbars=1,screenx=15,screeny=15,toolbar=no,opener=orig')" href="http://www.nextechdirectory.com" target="NewPopUpWindow"><img src="FooterLogo2.gif" alt="" border="0" /></a> <a id="Footer_hlFooter3" href="http://www.nex-tech.com/ebillsignup.aspx" target="_blank"><img src="FooterLogo3.gif" alt="" border="0" /></a> <a id="Footer_hlFooter4" href="http://www.nex-tech.com/Document.aspx?id=2764"><img src="FooterLogo4.gif" alt="" border="0" /></a> </td>
        <td valign=top align=right nowrap><a id="Footer_htFooter5" href="http://www.nex-tech.com" target="_blank"><img src="FooterLogo5.gif" alt="" border="0" /></a></td>
      </tr>
      <tr>
      
      <td valign=bottom colspan="2" width="100%">
      
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td valign=bottom class="CopyRight" nowrap>&nbsp;&nbsp;Copyright 2009 All Rights Reserved. Nex-Tech / A Rural Telephone Company. </td>
          <td valign=bottom class="CopyRight" align=right nowrap colspan="2">
        </td>
        </tr>
        <tr>
          <td colspan="3" class="Footer"></td>
        </tr>
      </table>
    </td>
    </tr>
    </tbody>
  </table>
  </td>
  </tr>
</table>
</body>
</HTML>
