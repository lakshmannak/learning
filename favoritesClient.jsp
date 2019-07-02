<%@ page import="javax.portlet.*"%>
<%@ page import="com.liferay.portal.kernel.util.PropsUtil"%>
<%@ page import="com.covisint.collaboration.sfx.portlet.Constants"%>
<%@ page import="com.covisint.collaboration.sfx.portlet.util.Utils"%>

<%@ page import="java.util.*"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@page import="org.owasp.esapi.Encoder"%>
<portlet:defineObjects />
<%
	String servletPath = Utils.getMergedPreferences(renderRequest, Constants.PROP_SERVICE_CONTEXT);
	String baseUrl = renderRequest.getPreferences().getValue(Constants.PREF_BASE_URL, null);
	String appRoot = 
                renderRequest.getPreferences().getValue(Constants.PREF_APPLICATION_ROOT, null);	
			
	String ssoId = Utils.getUserId(renderRequest);
	
	ResourceBundle rb = (ResourceBundle) request
			.getAttribute(Constants.RA_RESOURCE_BUNDLE);
	
	String namespace = renderResponse.getNamespace();
	String portletContextPath = renderResponse.encodeURL(renderRequest
			.getContextPath());
	Locale userLocale = request.getLocale();
	org.owasp.esapi.Encoder esapiEnc = org.owasp.esapi.reference.DefaultEncoder.getInstance();
	String commonQueryString = Constants.RP_PORTLET_CONTEXT_PATH + "="
			+ esapiEnc.encodeForJavaScript(portletContextPath) + "&" + Constants.REQ_APP_NAMESPACE
			+ "=" + portletConfig.getPortletName() + "&"
			+ Constants.REQ_WIN_NAMESPACE + "=" + esapiEnc.encodeForJavaScript(namespace) + "&"
			+ Constants.REQ_LOCALE_LANGUAGE + "="
			+ userLocale.getLanguage() + "&"
			+ Constants.REQ_LOCALE_COUNTRY + "="
			+ userLocale.getCountry() + "&"
			+ Constants.REQ_LOCALE_VARIANT + "="
			+ userLocale.getVariant() + "&" + Constants.RA_SSO_ID + "="
			+ ssoId + "&" + Constants.RA_APPLICATION_ROOT + "="
			+ appRoot;
	System.out.println("commonQueryString::: " +commonQueryString);
			
%>

<table width="100%">
	<tr>
		<td id='<%=namespace%>favority_div'>
			
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" id="<%=namespace%>favority_refresh" onclick="getFavorityData();" class="borderButton" value="Refresh" style="display:none;"/>
		</td>
	</tr>
</table>


<script type="text/javascript">

function <%=namespace%>hideIndicator2(){
	Ext.get("<%=namespace%>favority_div").unmask(false);
}

function <%=namespace%>showIndicator2(){
	Ext.get("<%=namespace%>favority_div").mask('<img src=\'<%=portletContextPath%>/images/loading.gif\' /> <%=rb.getString("application.processing")%>');
}

function getFavorityData(){
	var url = "<%=servletPath%>"+"/FavorityServlet";
	var queryString = "<%=commonQueryString%>" +'&baseUrl='+ "<%=baseUrl%>";
	<%=namespace%>showIndicator2();
	Ext.Ajax.request({
			url: url,
			method: 'post',
			params : queryString,
			callback: function(options,success,response){
				<%=namespace%>hideIndicator2();
				var favority_div = Ext.get("<%=namespace%>favority_div").dom;
				favority_div.innerHTML = response.responseText;
				Ext.get("<%=namespace%>favority_refresh").dom.style.display="block";
			}
	});
}

Ext.onReady(function()
{
	Ext.QuickTips.init();
  	Ext.Ajax.timeout = 1000*300;
	getFavorityData();

});
	
</script>

