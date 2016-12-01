<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>

<%
String cardimage1 = "http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=";
String cardimage = "";
String cardimage2 = "&type=card";
String cardback = "http://www.cliftonroadgames.co.uk/events/mtg_card-back.jpg";
String cardinput = request.getParameter("cardinput");
String deckname = request.getParameter("deckname");
String format = request.getParameter("format");
String colors = request.getParameter("colors");
String seed = request.getParameter("seed");
String decktrue = request.getParameter("decktrue");
String state = "0";
state = request.getParameter("state");

%>
<html>
<link rel="stylesheet" type="text/css" href="style.css">
<head>
<script type="text/javascript" src="jquery-3.1.1.min.js"></script>
<script type="text/javascript">
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
	function GetFormData(){
		
	}
</script>
</head>

<body>
		
		<div class="centered">

		
		<h1>
			<input type="button" value="Home" onclick="location.href='index.jsp'">
			EDIT DECK! (this page does not work yet)
		</h1>
		
		</div>
		
		<div class="centered div" id="choose_deck">
			
			<input type="button" value="Create A New Deck" onclick="location.href='new_deck.jsp'"/>
			<input type="button" value="Edit An Existing Deck" onclick="location.href='edit_deck.jsp'"/>
		</div>

		<div class="centered div" id="new_deck" style="display:none">
			<form action="." method="post" id="new_deck_form">
				ENTER A NEW DECK NAME:
				<input type="hidden" name="state" value="1">
				<input type="text" name="deckname">
				<br>
				ENTER A FORMAT:
				<input type="text" name="format">
				<br>
				ENTER COLORS:
				<input type="text" name="colors">
				<br>
				ENTER A CARD SEED:
				<input type="text" name="seed">
				<input type="submit" value="Create Deck"/>
			</form>	
		</div>
		
		<div class="centered div" id="existing_deck" style="display:none">
		
			<form method="post" id="new_deck_form">
				CHOOSE AN EXISTING DECK:
				<input type="hidden" name="state" value="2">
				<input type="text" name="deckname">
				<input type="submit" value="Edit Deck"/>
			</form>
		</div>
		

		

		<input type="button" value="Show" onclick="ShowDiv('toggle')"></input>
		<div id="toggle" style="display:none">WELCOME</div>
		
		
		
		
		
</body>



<script>
	
	function initial_setup(){
		document.getElementById('choose_deck').style.display="block";
		for(i=0;i<)
	}
	
	function change_state(old_state, new_state){
		document.getElementById(old_state).style.display="none";
		document.getElementById(new_state).style.display="block";
	}
	
	function openContent(content_id){
		document.getElementById(content_id).style.display="block";
	}
	
	$(document).ready(function(){
		$("button").click(function(){
			$("#div1").load("https://api.magicthegathering.io/v1/cards?name=\"anger\"");
			// $.get("https://api.magicthegathering.io/v1/cards?name='anger'", function(data,status){
				
				// alert("Data: "+data);
			// });
		});
	});
	
	$('#myButton').click(function(){
			$('#myDiv').toggle('slow', function(){
				
			});
		});
		
	
</script>

</html>