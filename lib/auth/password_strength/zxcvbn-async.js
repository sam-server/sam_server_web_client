(function(){
	var a;a=function(){
		var a,b;
		b=document.createElement("script");
		b.src="packages/sam_server_web_client/auth/password_strength/zxcvbn.js";b.type="text/javascript";
		b.async=!0;
		a=document.getElementsByTagName("script")[0];
		return a.parentNode.insertBefore(b,a)};
		null!=window.attachEvent?window.attachEvent("onload",a):
			window.addEventListener("load",a,!1)
	}
).call(this);
