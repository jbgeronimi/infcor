<?php
	$result_max_count = 100;

	// Paramtre de connection
	$db_name = "adecec_infcor";
	$db_host = "10.0.215.24";
	$db_user = "adecec_infcor";
	$db_password = "inf58david11";

	// Connexion ˆ la base INFCOR
	$connexion = mysql_connect($db_host, $db_user, $db_password, true, 65536) or die ("Erreur de connexion au serveur");
	$bdd = mysql_select_db($db_name, $connexion) or die ("Base de donnŽes introuvable");

	// Requte SQL
	$result = mysql_query("CALL rechercher('" . $c . "', " . $sc . ", " . $l . ");", $connexion) or die(mysql_error());
	$result_count = mysql_num_rows($result);

	// Fermeture de la connection
	mysql_close($connexion);

	echo('<?xml version="1.0" encoding="UTF-8"?>');

	if($result_count > $result_max_count){
		echo "<resultats mot=\"".$c."\" nombre=\"-1\">";
	}else{
		echo "<resultats mot=\"".$c."\" nombre=\"".$result_count."\">";
		
		while($row = mysql_fetch_object($result)){
			$mots = array();
		
			$mots_splittes = explode(",", $row->PAROLLA);
		
			for($index=0; $index<count($mots_splittes); $index++){
				if(trim($mots_splittes[$index]) != ""){
					$mots[count($mots)] = trim($mots_splittes[$index]);
				}
			}

			$mots_splittes = explode(",", $row->VARIANTESD);
			for($index=0; $index<count($mots_splittes); $index++){
				if(trim($mots_splittes[$index]) != ""){
					$mots[count($mots)] = trim($mots_splittes[$index]);
				}
			}
		
			$mots_splittes = explode(",", $row->ID1);
			for($index=0; $index<count($mots_splittes); $index++){
				if(trim($mots_splittes[$index]) != ""){
					$mots[count($mots)] = trim($mots_splittes[$index]);
				}
			}

			$mots = array_unique($mots);
		
			$affissaparolla = "";
			for($index=0; $index<count($mots); $index++){
				if($index > 0){
					$affissaparolla .= ", ";
				}
				$affissaparolla .= $mots[$index];
			}

			echo "<resultat>";
			echo "<mot>".utf8_encode($affissaparolla)."</mot>";
			echo "<traduction>".utf8_encode($row->FRANCESE)."</traduction>";
			echo "<definition>".utf8_encode(str_replace("’","'",$row->DEFINIZIONE))."</definition>";
			echo "<synonymes>".utf8_encode($row->SINONIMI)."</synonymes>";
			echo "</resultat>";
		}
	}

	echo "</resultats>";
?>
