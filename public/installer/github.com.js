if(window.location.pathname.indexOf("/issues") != -1) {
  //only inject script on issues page
  window.onload = function(){
    var script = document.createElement('script');
    script.type = "text/javascript";
    script.src = "https://issue-tracker.herokuapp.com/issue-tracker.js?" + (new Date()).getTime();
    document.body.appendChild(script);
  }
}

