var name;
var result;
var object;
var card;
var cardimgURL;
var cardlist;
var deckname;
var table;
var row;
var cell;
var limit_cards = 60;
var count_cards = 0;
var accepted_colors = ["White","Blue","Black","Red","Green"];
var accepted_identities = ["W","U","B","R","G"];
var deck = [];
var namelist = [];
var format = "Standard";


function ShowDiv(toggle){
	document.getElementById(toggle).style.display = 'block';
}
function RemoveDiv(untoggle){
	document.getElementById(untoggle).style.display = 'none';
}
function RemoveAllDiv(classname){
	var i, list;
	
	list = document.getElementsByClassName(classname);
	for(i=0; i<list.length; i++){
		list[i].style.display = 'none';
	}
}