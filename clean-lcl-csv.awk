#! /usr/bin/awk -f
# Created : Denis-Gilles Laurent / 24/10/2017
# Usage : tr.awk cc.xls
# date_valeur T montant T support T #Chq T beneficaire si - T beneficaire si +
# support = rien si bene+
# bene - = (Rien si support = chèque) | [.CB.. si Carte Sauf TOTAL OPTION SYSTEM' EPARGNE][PRLV. si Virement]+ [RETRAIT DU JJ/MM | TIERS .* JJ/MM/YY]

# http://melpa.org/#/getting-started
# https://github.com/victorhge/iedit
# Ajouter un outil de renommage de variable
# Pourquoi le test sur cotisation fonctionne pas ?

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }


BEGIN {
 FS = "\t"
 TYPE_CHK = "Chèque"
 TYPE_CARD = "Carte"
 TYPE_TRANSFERT = "Virement"

 PAYEE_TOTAL = "TOTAL OPTION SYSTEM' EPARGNE    "
 PAYEE_COTISATION = "COTISATION MENSUELLE CARTE"
 PAYEE_CARD = " CB  "
 PAYEE_TRANSFERT = "PRLV "
 PAYEE_WITHDRAWAL = " CB  RETRAIT DU  "

 printf "set %s\n", PAYEE_TOTAL 
} ;

{
    valueDate = $1
    amount = $2
    type = $3
    checkNum = $4
    payeeExpsense = $5
    payeeIncome = $6
	
    tsnDate = valueDate
    payee = payeeExpsense
    tsnMemo = ""

    check = 0
    
    if (type == TYPE_CARD) {
	switch(payeeExpsense) {
	    case "PAYEE_TOTAL" : 
		payee = trim(payeeExpsense)
		check = 1
		break;
		
	    case /COTISATION.*/ : 
		payee = trim(payeeExpsense)
		check = 1
		break;

		default : 
		    if (index(payeeExpsense, PAYEE_WITHDRAWAL) == 1) {
			dateBegin = substr(payeeExpsense,length(PAYEE_WITHDRAWAL)+1, 5)
			payee = "RETRAIT"
			tsnDate = dateBegin strftime("/%Y")
			check = 1
			
		    } else {
			#printf "0 %s\n", payeeExpsense
			payee = substr(payeeExpsense, length(PAYEE_CARD)+1, length(payeeExpsense)-10-length(PAYEE_CARD))
			#printf "1 %s du %s\n", payee, tsnDate
			tsnDate = substr(payeeExpsense, length(payeeExpsense)-9, 5)
			tsnDate = tsnDate strftime("/%Y")
			
			#payee = sub(/[ ]+$/,"", payee)
			payee=rtrim(payee)
			#printf "2 %s du %s\n", payee, tsnDate
			#printf "Carte pour %s \n", payeeExpsense
			check = 1
		    }
		    break
	}
    }

    if (check == 1) {
	printf "date: %s, montant: %s, tiers: %s, memo: %s\n", tsnDate, amount, payee, tsnMemo
    } else {
	printf "unprocessed : %s\n", $0
    }
    # printf "date valeur : %s", $1;
    # printf " / montant : %s", $2;
    # printf " / carte/chèque/virement : %s", $3;
    # printf " / #chèque : %s", $4;
    # printf " / bene- : %s\n", $5;
    # printf " / bene+ : %s\n", $6;
	
}

