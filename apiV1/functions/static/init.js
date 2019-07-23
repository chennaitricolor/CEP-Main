var API = "https://us-central1-tech-for-cities.cloudfunctions.net/api";
var url = new URL(window.location.href);
var token = url.searchParams.get('token');
var xhttp = new XMLHttpRequest();
xhttp.open("POST", `${API}/user/${token}`, true);
xhttp.send();
xhttp.onreadystatechange = function (res){
    if(xhttp.readyState === 4 && xhttp.status === 200){
        let result = JSON.parse(xhttp.responseText);
        localStorage.setItem('user',JSON.stringify(result.data));
        window.location.href="./"
    }
};