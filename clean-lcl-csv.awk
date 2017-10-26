#! /usr/bin/awk -f
# Created : Denis-Gilles Laurent / 24/10/2017
# Usage : tr.awk cc.xls
# date_valeur T montant T support T #Chq T beneficaire si - T beneficaire si +
# support = rien si bene+
# bene - = (Rien si support = chèque) | [.CB.. si Carte Sauf TOTAL OPTION SYSTEM' EPARGNE][PRLV. si Virement]+ [RETRAIT DU JJ/MM | TIERS .* JJ/MM/YY]

# http://melpa.org/#/getting-started
# https://github.com/victorhge/iedit
# Ajouter un outil de renommage de variable

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
    payeeExpense = $5
    payeeIncome = $6
	
    tsnDate = valueDate
    payee = payeeExpense
    tsnMemo = ""

    check = 0

    # printf "analyse : %s\n", $0
    # printf "date valeur : %s", $1;
    # printf " / montant : %s", $2;
    # printf " / carte/chèque/virement : %s", $3;
    # printf " / #chèque : %s", $4;
    # printf " / bene- : %s", $5;
    # printf " / bene+ : %s", $6;
    # printf "\n"

    
    if (type == TYPE_CARD) {
	switch(payeeExpense) {
	    case "PAYEE_TOTAL" : 
		payee = trim(payeeExpense)
		check = 1
		break;
		

		default : 
		    if (index(payeeExpense, PAYEE_WITHDRAWAL) == 1) {
			dateBegin = substr(payeeExpense,length(PAYEE_WITHDRAWAL)+1, 5)
			payee = "RETRAIT"
			tsnDate = dateBegin strftime("/%Y")
			check = 1
			
		    } else {
			#printf "0 %s\n", payeeExpense
			payee = substr(payeeExpense, length(PAYEE_CARD)+1, length(payeeExpense)-10-length(PAYEE_CARD))
			#printf "1 %s du %s\n", payee, tsnDate
			tsnDate = substr(payeeExpense, length(payeeExpense)-9, 5)
			tsnDate = tsnDate strftime("/%Y")
			
			#payee = sub(/[ ]+$/,"", payee)
			payee=rtrim(payee)
			#printf "2 %s du %s\n", payee, tsnDate
			#printf "Carte pour %s \n", payeeExpense
			check = 1
		    }
		    break
	}
    }

    if ((type == "") && (index(payeeIncome,PAYEE_COTISATION) == 1) ) {
	payee = trim(payeeIncome)
	check = 1

    }

    if (check == 1) {
	printf "date: %s, montant: %s, tiers: %s, memo: %s\n", tsnDate, amount, payee, tsnMemo
    } else {
	printf "unprocessed : %s\n", $0
    }
	
}

