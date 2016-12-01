<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>


<html>
	<link rel="stylesheet" type="text/css" href="style.css">
	<head>
		<script type="text/javascript" src="jquery-3.1.1.min.js">
		</script>
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
		
		<script type="text/javascript">
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
	
		</script>
	</head>

	<body>
			<div class="centered">
				<h1>
					<input type="button" value="Home" onclick="location.href='index.jsp'">
					NEW DECK!
				</h1>
			</div>
			
			<script type="text/javascript">
				
			</script>
			
			<div class="centered div" id="new_deck">
				<form action="new_deck.jsp" method="post" id="new_deck_form">
					ENTER A DECK NAME:
					<input id="deckname" type="text" name="deckname">
					<input type="button" value="Change Deck Name" onclick="AddDeckName()"/>
					<br>
					<br>
					SELECT A DECK FORMAT:
					<select id="sel_format">
						<option value="Standard">Standard</option>
						<option value="Commander">Commander/EDH</option>
						<option value="Modern">Modern</option>
						<option value="Vintage">Vintage</option>
						<option value="Legacy">Legacy</option>
						<option value="Other">Other</option>
					</select>
					<input type="button" value="Change Deck Type" onclick="setFormat()"/>
					<br>
					<br>
					SELECT THE DECK COLORS:
					<select id="deck_color">
						<option value="">Colorless</option>
						<option value="W">White (W)</option>
						<option value="U">Blue (U)</option>
						<option value="B">Black (B)</option>
						<option value="R">Red (R)</option>
						<option value="G">Green (G)</option>
						<option value="WU">Azorius (WU)</option>
						<option value="WB">Orzhov (WB)</option>
						<option value="WR">Boros (WR)</option>
						<option value="WG">Selesnya (WG)</option>
						<option value="UB">Dimir (UB)</option>
						<option value="UR">Izzet (UR)</option>
						<option value="UG">Simic (UG)</option>
						<option value="BR">Rakdos (BR)</option>
						<option value="BG">Golgari (BG)</option>
						<option value="RG">Gruul (RG)</option>
						<option value="WUB">Esper (UWB)</option>
						<option value="WUR">Jeskai (URW)</option>
						<option value="WUG">Bant (WGU)</option>
						<option value="WBR">Mardu (RWB)</option>
						<option value="WBG">Abzan (WBG)</option>
						<option value="WRG">Naya (GWR)</option>
						<option value="UBR">Grixis (BRU)</option>
						<option value="UBG">Sultai (BUG)</option>
						<option value="BRG">Jund (RGB)</option>
						<option value="WUBR">Yore (WUBR)</option>
						<option value="UBRG">Glint-Eye (UBRG)</option>
						<option value="BRGW">Dune (BRGW)</option>
						<option value="RGWU">Ink-Treader (RGWU)</option>
						<option value="GWUB">Witch (GWUB)</option>
						<option value="WUBRG">Rainbow (WUBRG)</option>
						
					</select>
					<input type="button" value="Change Deck Colors" onclick="setColors()"/>
					<br>
					<br>
					ENTER A CARD SEED:
					<input id="card_seed" type="text" name="seed">
					<input type="button" value="Add Seed To Deck" onclick="AddCardToDeck()"/>
					<br><br>
					<input type="button" value="Suggest Cards" onclick="AddCardsToSugg()"/>
				</form>	
			</div>
			
			<div>
				
				<table id="decklinks" style="display:inline-block; margin-left:100px; border:1px solid black; border-collapse:collapse; float:left">
					<tr>
						<th style="border:1px solid black; width:250px">Deck</th>
						<th style="border:1px solid black; width:10px"></th>
					</tr>
				</table>
				<table id="sugglinks" style="display:inline-block; margin-left:20px; border:1px solid black; border-collapse:collapse">
					<tr>
						<th style="border:1px solid black; width:250px">Suggested Cards</th>
						<th style="border:1px solid black; width:10px"></th>
					</tr>
				</table>
			</div>
			<img id="displayimg" src="http://www.cliftonroadgames.co.uk/events/mtg_card-back.jpg" style="position:fixed; bottom:10px; right:10px; width:300px; height:400px"/>
			<script type="text/javascript">
			function setFormat(){
				format = document.getElementById("sel_format").value;
				if(format=="Standard"){
					limit_cards = 60;
				}
				else if(format=="Commander"){
					limit_cards = 100;
				}
				else if(format=="Modern"){
					limit_cards = 60;
				}
				else if(format=="Vintage"){
					limit_cards = 60;
				}
				else if(format=="Legacy"){
					limit_cards = 60;
				}
				else{
					limit_cards = 200;
				}
				//alert("limit_cards = " + limit_cards);
			}
			
			function setColors(){
				accepted_identities = Array.from(document.getElementById("deck_color").value);
			}
			
			function AddCardToDeck(){
				if(count_cards < limit_cards){
					oldname=document.getElementById("card_seed").value;
					name=oldname.replace(/\s/g, "%20");
					
					$.getJSON("https://api.magicthegathering.io/v1/cards?name=\""+name+"\"", function (json) {
						if(json.cards!=""){
							DeckInsert(oldname);
							document.getElementById("card_seed").value="";
							count_cards++;
							deck.push(json.cards[json.cards.length - 1]);
							//alert(deck);
						}
						else{
							alert("Not a valid card name.");
						}
					});
				}
				else{
					alert("Limit of cards has been reached for this format.");
				}
			}
			
			function AddCardsToSugg(){
				if(count_cards > 0){
					//get keywords from cards in seedlist(existing cards in deck) and search the mtg api for other cards with keywords
					//display 10 max of each returned
					//search cards by color, type, keywords, cmc
					//if commander deck, if no commander selected, suggest commanders
					
					
				}
				else{
					if(format=="Commander"){
						var pagnum=1;
						var colors = accepted_identities.join("|");
						// alert(colors);
						// alert(pagnum.toString());
						var addcard;
						var jsoncount;
						for(pagnum=1;pagnum<3;pagnum++){
							$.getJSON("https://api.magicthegathering.io/v1/cards?page="+pagnum.toString()+"&type=Legendary%20Creature&colorIdentity=\""+colors+"\"",function(json){
								if(json.cards!=""){
								$.each(json.cards, function (i, card) {
									addcard=true;
									for(i=0;i<namelist.length;i++){
										if(namelist[i].name==card.name){
											addcard=false;
											break;
										}
									}
									if(addcard){
										namelist.push(card);
									}
								});
								namelist = _.sortBy(namelist, 'subtypes');
								for(i=0;i<namelist.length;i++){
									SuggInsert(namelist[i].name);
								}
								}
							});
						}
					}
					else{
						alert("Please enter a Card Seed first");
					}
				}
				
				//Math.floor((Math.random() * 10));
			}
			
			function RemoveCardFromDeck(){
				
			}
			
			function RemoveCardFromSugg(){
				
			}
			
			function AddDeckName() {
				deckname=document.getElementById("deckname").value;
				table = document.getElementById("decklinks");
				
				table.deleteRow(0);
				row = table.insertRow(0);
				row.innerHTML = "<th style='border:1px solid black; width:250px'>"+deckname+"</th><th style='border:1px solid black; width:10px'></th>";
			}
			
			function SuggToDeckInsert(name_of_card){
				if(count_cards < limit_cards){
					DeckInsert(name_of_card);
					count_cards++;
					RemoveCardFromSugg(name_of_card);
				}
				else{
					alert("Limit of cards has been reached for this format.");
				}
			}
			
			function DeckInsert(name_of_card) {
				table = document.getElementById("decklinks");
				row = table.insertRow(table.length);
				row.innerHTML = "<th style='border:1px solid black; width:250px'><a href='javascript:changeImage(\""+name_of_card+"\")'>"+name_of_card+"</a></th><th style='border:1px solid black; width:10px'><input type='button' value='Remove Card' onclick='RemoveCardFromDeck()'/></th>";
			}
			
			function SuggInsert(name_of_card){
				table = document.getElementById("sugglinks");
				row = table.insertRow(table.length);
				row.innerHTML = "<th style='border:1px solid black; width:250px'><a href='javascript:changeImage(\""+name_of_card+"\")'>"+name_of_card+"</a></th><th style='border:1px solid black; width:10px'><input type='button' value='Add to Deck' onclick='SuggToDeckInsert(\""+name_of_card+"\")'/></th>";
			}
			
			function changeImage(oldname){
				name=oldname.replace(/\s/g, "%20");
				
				$.getJSON("https://api.magicthegathering.io/v1/cards?name=\""+name+"\"", function (json) {
					var mvid = json.cards[json.cards.length - 1].multiverseid;
					document.getElementById("displayimg").src="http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid="+mvid+"&type=card";
				});
				
			}
				
			</script>	
	</body>

</html>