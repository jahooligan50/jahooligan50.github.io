<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>


<html>
	<link rel="stylesheet" type="text/css" href="style.css">
	<head>
		<script type="text/javascript" src="jquery-3.1.1.min.js"></script>
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
		<script type="text/javascript" src="prescript.js"></script>
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
						<th id="fileName" style="border:1px solid black; width:250px">Deck</th>
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
			
			<input type="button" id="download_btn" value="Download Deck Text File" onclick="saveTextAsFile()" style="position:fixed; top:10px; right:-140px; width:300px; height:100px"/>
			<img id="displayimg" src="http://www.cliftonroadgames.co.uk/events/mtg_card-back.jpg" style="position:fixed; bottom:10px; right:10px; width:300px; height:400px"/>
			
			
			<script type="text/javascript" src="postscript.js"></script>	
	</body>

</html>