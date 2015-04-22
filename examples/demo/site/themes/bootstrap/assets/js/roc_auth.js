var loginURL = "/login";
var logoutURL = "/logoff";
var userAgent = navigator.userAgent.toLowerCase();
var firstLogIn = true;
 
var login = function() {
    var form = document.forms[0];
    var username = form.username.value;
    var password = form.password.value;
	  //var host = form.host.value;
  	var host = window.location.hostname;
    var _login = function(){

 
    if  (document.getElementById('myModalFormId') !== null ) {
        remove ('myModalFormId');
    }


	if (username === "" || password === "") {
             if (document.getElementById('myModalFormId') === null ) {		
                    var newdiv = document.createElement('div');
	                  newdiv.innerHTML = "<br>Invalid Credentials</br>";
                    newdiv.id = 'myModalFormId';
                     $("body").append(newdiv);
               } 
	}else{  
         
          //Instantiate HTTP Request
          var request = ((window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP"));
    	    request.open("GET", loginURL, true, username, password);
	        request.send(null);
    
          //Process Response
          request.onreadystatechange = function(){
             if (request.readyState == 4) {
                 if (request.status==200) {
                           delete form
                           window.location=host.concat("/");
                }
                else{
                  if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1){                       
                     }
                   
		  if (document.getElementById('myModalFormId') === null ) {		
                    var newdiv = document.createElement('div');
	                   newdiv.innerHTML = "<br>Invalid Credentials</br>";
                    newdiv.id = 'myModalFormId';
                    $("body").append(newdiv);
                   } 

                  }
               }
            }
        }
    }
 
    var userAgent = navigator.userAgent.toLowerCase();
    if (userAgent.indexOf("firefox") != -1){ //TODO: check version number
        if (firstLogIn) _login();
        else logoff(_login);
    }
    else{
        _login();
    }
 
    if (firstLogIn) firstLogIn = false;
};


var login_with_redirect = function() {
    var form = document.forms[2];
    var username = form.username.value;
    var password = form.password.value;
    var host = form.host.value;
    var _login = function(){

    var redirectURL = form.redirect && form.redirect.value || "";   


    $("#imgProgressRedirect").show();  

    if  (document.getElementById('myModalFormId') !== null ) {
        remove ('myModalFormId');
    }


    if (username === "" || password === "") {
             if (document.getElementById('myModalFormId') === null ) {      
                    var newdiv = document.createElement('div');
                      newdiv.innerHTML = "<br>Invalid Credentials</br>";
                    newdiv.id = 'myModalFormId';
                    $("body").append(newdiv);
                     $("#imgProgressRedirect").hide();
               } 
    }else{  
         
          //Instantiate HTTP Request
          var request = ((window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP"));
            request.open("GET", host.concat(loginURL), true, username, password);
            request.send(null);
    
          //Process Response
          request.onreadystatechange = function(){
             if (request.readyState == 4) {
                 if (request.status==200) {
                     if (redirectURL === "") {   
                        window.location=host.concat("/");
                    } else {
                        window.location=host.concat(redirectURL);
                    }

        }
                else{
                  if (navigator.userAgent.toLowerCase().indexOf("firefox") != -1){                       
                     }
                   
          if (document.getElementById('myModalFormId') === null ) {     
                    var newdiv = document.createElement('div');
                       newdiv.innerHTML = "<br>Invalid Credentials</br>";
                    newdiv.id = 'myModalFormId';
                    $("body").append(newdiv);
                     $("#imgProgressRedirect").hide();    
                   } 

                  }
               }
            }
        }
    }
 
    var userAgent = navigator.userAgent.toLowerCase();
    if (userAgent.indexOf("firefox") != -1){ //TODO: check version number
        if (firstLogIn) _login();
        else logoff(_login);
    }
    else{
        _login();
    }
 
    if (firstLogIn) firstLogIn = false;
};

 
 
var logoff = function(callback){
	   var form = document.forms[0];
     var host = form.host.value;
	  
    if (userAgent.indexOf("msie") != -1) {
        document.execCommand("ClearAuthenticationCache");
    }
    else if (userAgent.indexOf("firefox") != -1){ //TODO: check version number
 
        var request1 = new XMLHttpRequest();
        var request2 = new XMLHttpRequest();
 
      //Logout. Tell the server not to return the "WWW-Authenticate" header
        request1.open("GET", host.concat(logoutURL) + "?prompt=false", true);
        request1.send("");
        request1.onreadystatechange = function(){
            if (request1.readyState == 4) {
 
              //Sign in with dummy credentials to clear the auth cache
                request2.open("GET", host.concat(logoutURL), true, "logout", "logout");
                request2.send("");
 
                request2.onreadystatechange = function(){
                    if (request2.readyState == 4) {
                        if (callback!=null) { callback.call();  } else { window.location=host.concat(logoutURL);}
                    } 
                }
                 
            }
        }
    }
    else {
        var request = ((window.XMLHttpRequest) ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP"));
        request.open("GET", host.concat(logoutURL), true, "logout", "logout");
        request.send("");
        request.onreadystatechange = function(){
                   if (request.status==401 || request.status==403 ) { window.location=host.concat(logoutURL);
                } 
            }
    }
};


function remove(id)
{
   var element = document.getElementById(id);
   element.outerHTML = "";
   delete element;
   return;
};



$(document).ready(function() {

  if (typeof String.prototype.contains != 'function') {
    String.prototype.contains = function (str){
      return this.indexOf(str) != -1;
    };
  }
   progressive_loging();

});


var progressive_loging = function () {

    login_href();
};







var OnOneClick = function(event) {
  event.preventDefault();
  if  ( document.forms[0] === undefined ) {
    create_form();
  }
  this.focus;
  return false;
};

var login_href = function() {
  var els = document.getElementsByTagName("a");
  for (var i = 0, l = els.length; i < l; i++) {
      var el = els[i];
      if (el.href.contains("/basic_auth_login?destination")) {
        loginURL = el.href;
        var OneClick = el;
        OneClick.addEventListener('click', OnOneClick, false);
     }
  }
};


var create_form = function() {

    // Fetching HTML Elements in Variables by ID.
  var createform = document.createElement('form'); // Create New Element Form
  createform.setAttribute("action", ""); // Setting Action Attribute on Form
  createform.setAttribute("method", "post"); // Setting Method Attribute on Form
  $("body").append(createform); 

  var heading = document.createElement('h2'); // Heading of Form
  heading.innerHTML = "Login Form ";
  createform.appendChild(heading);

  var line = document.createElement('hr'); // Giving Horizontal Row After Heading
  createform.appendChild(line);

  var linebreak = document.createElement('br');
  createform.appendChild(linebreak);

  var namelabel = document.createElement('label'); // Create Label for Name Field
  namelabel.innerHTML = "Username : "; // Set Field Labels
  createform.appendChild(namelabel);

  var inputelement = document.createElement('input'); // Create Input Field for UserName
  inputelement.setAttribute("type", "text");
  inputelement.setAttribute("name", "username");
  inputelement.setAttribute("required","required");
  createform.appendChild(inputelement);

  var linebreak = document.createElement('br');
  createform.appendChild(linebreak);

  var passwordlabel = document.createElement('label'); // Create Label for Password Field
  passwordlabel.innerHTML = "Password : ";
  createform.appendChild(passwordlabel);

  var passwordelement = document.createElement('input'); // Create Input Field for Password.
  passwordelement.setAttribute("type", "password");
  passwordelement.setAttribute("name", "password");
  passwordelement.setAttribute("id", "password");
  passwordelement.setAttribute("required","required");
  createform.appendChild(passwordelement);


  var passwordbreak = document.createElement('br');
  createform.appendChild(passwordbreak);


  var submitelement = document.createElement('button'); // Append Submit Button
  submitelement.setAttribute("type", "button");
  submitelement.setAttribute("onclick", "login();");
  submitelement.innerHTML = "Sign In ";
  createform.appendChild(submitelement);

};


