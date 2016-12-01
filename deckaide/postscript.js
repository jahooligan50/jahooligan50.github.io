function saveTextAsFile()
{
    var textToWrite = "";
	for(i=0;i<deck.length;i++){
		textToWrite += "1 " + deck[i].name + "\n";
	}
    var textFileAsBlob = new Blob([textToWrite], {type:'text/plain'});
    var fileNameToSaveAs = document.getElementById("fileName").value + ".txt";
      var downloadLink = document.createElement("a");
    downloadLink.download = fileNameToSaveAs;
    downloadLink.innerHTML = "Download File";
    if (window.webkitURL != null)
    {
        // Chrome allows the link to be clicked
        // without actually adding it to the DOM.
        downloadLink.href = window.webkitURL.createObjectURL(textFileAsBlob);
    }
    else
    {
        // Firefox requires the link to be added to the DOM
        // before it can be clicked.
        downloadLink.href = window.URL.createObjectURL(textFileAsBlob);
        downloadLink.onclick = destroyClickedElement;
        downloadLink.style.display = "none";
        document.body.appendChild(downloadLink);
    }

    downloadLink.click();
}

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
		//name=name.replace(/'/g, "%27");
		
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
	//first remove all old suggestions
	for(i=namelist.length-1;i>=0;i--){
		RemoveCardFromSugg(namelist[i].name);
	}
	
	if(count_cards > 0){
		//get keywords from cards in seedlist(existing cards in deck) and search the mtg api for other cards with keywords
		//display 30 max of each type of card (creature, artifact, enchantment, etc...) returned
		//search cards by color, type(if tribal indicated), keywords(most relevant), cmc(range of lowest seed cmc -1 to highest seed cmc +1)
		//if commander deck, if no commander selected, suggest commanders
		//supply max of twice amount of deck.
		
		var cmc_low = 99;
		var cmc_high = 0;
		var keywords_available = ["Deathtouch", "Defender", "Double Strike", "Enchant", "Equip", "First Strike", "Flash", "Flying", "Haste", "Hexproof", "Indestructible", "Intimidate", "Landwalk", "Plainswalk", "Islandwalk", "Swampwalk", "Mountainwalk", "Forestwalk", "Lifelink", "Protection", "Reach", "Shroud", "Trample", "Vigilance", "Banding", "Rampage", "Cumulative Upkeep", "Flanking", "Phasing", "Buyback", "Shadow", "Cycling", "Echo", "Horsemanship", "Fading", "Kicker", "Flashback", "Madness", "Fear", "Morph", "Amplify", "Provoke", "Storm", "Affinity", "Entwine", "Modular", "Sunburst", "Bushido", "Soulshift", "Splice", "Offering", "Ninjitsu", "Epic", "Convoke", "Dredge", "Transmute", "Bloodthirst", "Haunt", "Replicate", "Forecast", "Graft", "Recover", "Ripple", "Split Second", "Suspend", "Vanishing", "Absorb", "Aura Swap", "Delve", "Foritfy", "Frenzy", "Gravestorm", "Poisonous", "Transfigure", "Champion", "Changeling", "Evoke", "Hideaway", "Prowl", "Reinforce", "Conspire", "Persist", "Wither", "Retrace", "Devour", "Exalted", "Unearth", "Cascade", "Annihilator", "Level Up", "Rebound", "Totem Armor", "Infect", "Battle Cry", "Living Weapon", "Undying", "Miracle", "Soulbond", "Overload", "Scavenge", "Unleash", "Cipher", "Evolve", "Extort", "Fuse", "Bestow", "Tribute", "Dethrone", "Hidden Agenda", "Outlast", "Prowess", "Dash", "Exploit", "Menace", "Renown", "Awaken", "Devoid", "Ingest", "Myriad", "Surge", "Skulk", "Emerge", "Escalate", "Melee", "Crew", "Fabricate", "Partner", "Undaunted"];
		var abilities_available = ["Battalion", "Bloodrush", "Channel", "Chroma", "Cohort", "Constellation", "Converge", "Delirium", "Domain", "Fateful hour", "Ferocious", "Formidable", "Grandeur", "Hellbent", "Heroic", "Imprint", "Inspired", "Join forces", "Kinship", "Landfall", "Lieutenant", "Metalcraft", "Morbid", "Parley", "Radiance", "Raid", "Rally", "Spell mastery", "Strive", "Sweep", "Tempting offer", "Threshold", "Will of the council"];
		var actions_available = ["Monstrosity", "Populate", "Regenerate", "Monstrous", "Tokens", "Detain", "Clash", "Monarch", "Abandon", "Bolster", "Fateseal", "Goad", "Investigate", "Manifest", "Meld", "Planeswalk", "Proliferate", "Set in Motion", "Support", "Transform", "Vote"];
		var other_keywords = ["Activate", "Attach", "Cast", "Counter", "Create", "Destroy", "Discard", "Exchange", "Exile", "Fight", "Play", "Reveal", "Sacrifice", "Scry", "Search", "Shuffle", "Tap", "Untap", "{T}", "{Q}", "enters the battlefield"];

		var keywords = [];
		var j,k;
		
		for(i=0;i<deck.length;i++){
			if(deck[i].cmc <cmc_low){
				cmc_low = deck[i].cmc;
			}
			if(deck[i].cmc > cmc_high){
				cmc_high = deck[i].cmc;
			}
			// for(j=0;j<keywords_available.length;j++){
				// for(k=0;k<keywords.length;k++){
					// if(keywords[k] != keywords_available[j]){
						// if(deck[i].originalText.search(keywords_available[j]) != -1){
							// keywords.push(keywords_available[j]);
						// }
					// }
				// }
				// if(keywords.length==0){
					// if(deck[i].originalText.search(keywords_available[j]) != -1){
						// keywords.push(keywords_available[j]);
					// }
				// }
			// }
			// for(j=0;j<abilities_available.length;j++){
				// for(k=0;k<keywords.length;k++){
					// if(keywords[k] != abilities_available[j]){
						// if(deck[i].originalText.search(abilities_available[j]) != -1){
							// keywords.push(abilities_available[j]);
						// }
					// }
				// }
				// if(keywords.length==0){
					// if(deck[i].originalText.search(abilities_available[j]) != -1){
						// keywords.push(abilities_available[j]);
					// }
				// }
			// }
			// for(j=0;j<actions_available.length;j++){
				// for(k=0;k<keywords.length;k++){
					// if(keywords[k] != actions_available[j]){
						// if(deck[i].originalText.search(actions_available[j]) != -1){
							// keywords.push(actions_available[j]);
						// }
					// }
				// }
				// if(keywords.length==0){
					// if(deck[i].originalText.search(actions_available[j]) != -1){
						// keywords.push(actions_available[j]);
					// }
				// }
			// }
			// for(j=0;j<other_keywords.length;j++){
				// for(k=0;k<keywords.length;k++){
					// if(keywords[k] != other_keywords[j]){
						// if(deck[i].originalText.search(other_keywords[j]) != -1){
							// keywords.push(other_keywords[j]);
						// }
					// }
				// }
				// if(keywords.length==0){
					// if(deck[i].originalText.search(other_keywords[j]) != -1){
						// keywords.push(other_keywords[j]);
					// }
				// }
			// }
		}
		// alert(keywords);

		
		cmc_high++;
		if(cmc_low!=0){
			cmc_low--;
		}
		
		var pagnum;
		var colors;
		for(i=0;i<deck.length;i++){
			colors=deck[i].colorIdentity.join("");
		}
		//var colors = accepted_identities.join("|");
		// alert(colors);
		// alert(pagnum.toString());
		var addcard;
		var printstuff = false;
		var instants = 0;
		var sorceries = 0;
		var enchantments = 0;
		var planeswalkers = 0;
		var artifacts = 0;
		var creatures = 0;
		var lands = 0;
		var minilist = [];
		var namecount = 0;
		for(pagnum=1;pagnum<30;pagnum++){
			$.getJSON("https://api.magicthegathering.io/v1/cards?page="+pagnum.toString()+"&gameFormat="+format+"&types=Instant|Sorcery|Creature|Planeswalker|Artifact|Enchantment",function(json){
				//minilist.length=0;
					if(json.cards!=""){
						$.each(json.cards, function (i, card) {
							addcard=true;
							for(i=0;i<card.colorIdentity.length;i++){
								if(card.colorIdentity[i].search(colors) == -1){
									addcard=false;
									break;
								}
							}
							if(card.cmc >cmc_high || card.cmc < cmc_low){
								addcard = false;
							}
							for(i=0;i<namelist.length;i++){
								
								if(namelist[i].name==card.name){
									addcard=false;
									break;
								}
								
							}
							// for(i=0;i<keywords.length;i++){
								// if(card.originalText.search(keywords[i]) != -1){
									// addcard=true;
									// break;
								// }
							// }
							for(i=0;i<card.types.length;i++){
								if(card.types[i] == "Instant" && instants>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Sorcery" && sorceries>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Creature" && creatures>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Enchantment" && enchantments>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Planeswalker" && planeswalkers>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Artifact" && artifacts>=30){
									addcard=false;
									break;
								}
								if(card.types[i] == "Land" && lands>=30){
									addcard=false;
									break;
								}
							}
							if(addcard){
								namelist.push(card);
								minilist.push(card);
								for(i=0;i<card.types.length;i++){
									if(card.types[i] == "Instant"){
										instants++;
										break;
									}
									if(card.types[i] == "Sorcery"){
										sorceries++;
										break;
									}
									if(card.types[i] == "Creature"){
										creatures++;
										break;
									}
									if(card.types[i] == "Enchantment"){
										enchantments++;
										break;
									}
									if(card.types[i] == "Planeswalker"){
										planeswalkers++;
										break;
									}
									if(card.types[i] == "Artifact"){
										artifacts++;
										break;
									}
									if(card.types[i] == "Land"){
										lands++;
										break;
									}
								}
							}
						});
						//minilist = _.sortBy(minilist, 'types');
					for(i=namecount;i<namelist.length;i++){
						SuggInsert(namelist[i].name);
					}
					namecount=i;
					}
					
			});
			
		}
		
		//alert(count_cards);
	}
	else{
		if(format=="Commander"){
			var pagnum;
			var colors = accepted_identities.join("|");
			// alert(colors);
			// alert(pagnum.toString());
			var addcard;
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

function RemoveCardFromDeck(name_of_card){
	table=document.getElementById("decklinks");
	for(i=1;i<table.rows.length;i++){
		if(table.rows[i].cells[0].id==name_of_card){
			table.deleteRow(i);
			break;
		}
	}
	for(i=0;i<deck.length;i++){
		if(deck[i].name==name_of_card){
			deck.splice(i, 1);
			break;
		}
	}
	count_cards--;
}

function RemoveCardFromSugg(name_of_card){
	table=document.getElementById("sugglinks");
	for(i=1;i<table.rows.length;i++){
		if(table.rows[i].cells[0].id==name_of_card){
			table.deleteRow(i);
			break;
		}
	}
	for(i=0;i<namelist.length;i++){
		if(namelist[i].name==name_of_card){
			deck.push(namelist[i]);
			namelist.splice(i, 1);
			break;
		}
	}
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
	idname=name_of_card.replace(/'/g, "%27");
	table = document.getElementById("decklinks");
	row = table.insertRow(table.length);
	row.id=name_of_card;
	row.innerHTML = "<th id='"+idname+"' style='border:1px solid black; width:250px'><a href='javascript:changeImage(\""+idname+"\")'>"+name_of_card+"</a></th><th style='border:1px solid black; width:10px'><input type='button' value='Remove Card' onclick='RemoveCardFromDeck(\""+idname+"\")'/></th>";
}

function SuggInsert(name_of_card){
	idname=name_of_card.replace(/'/g, "%27");
	table = document.getElementById("sugglinks");
	row = table.insertRow(table.length);
	row.id=name_of_card;
	row.innerHTML = "<th id='"+idname+"' style='border:1px solid black; width:250px'><a href='javascript:changeImage(\""+idname+"\")'>"+name_of_card+"</a></th><th style='border:1px solid black; width:10px'><input type='button' value='Add to Deck' onclick='SuggToDeckInsert(\""+idname+"\")'/></th>";
}

function changeImage(oldname){
	name=oldname.replace(/\s/g, "%20");
	name=name.replace(/'/g, "%27");
	//alert(oldname+name);
	$.getJSON("https://api.magicthegathering.io/v1/cards?name=\""+name+"\"", function (json) {
		var mvid = json.cards[json.cards.length - 1].multiverseid;
		document.getElementById("displayimg").src="http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid="+mvid+"&type=card";
	});
	
}
	