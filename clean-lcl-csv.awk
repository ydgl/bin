#! /usr/bin/awk -f
# Created : Denis-Gilles Laurent / 24/10/2017
# Usage : tr.awk cc.xls
# date_valeur T montant T support T #Chq T beneficaire si - T beneficaire si +
# support = rien si bene+
# bene - = (Rien si support = chèque) | [.CB.. si Carte Sauf TOTAL OPTION SYSTEM' EPARGNE][PRLV. si Virement]+ [RETRAIT DU JJ/MM | TIERS .* JJ/MM/YY]

# http://melpa.org/#/getting-started
# https://github.com/victorhge/iedit
# Ajouter un outil de renommage de variable
# https://www.johndcook.com/blog/emacs_windows/

# iconv -f ISO-8859-1 -t UTF-8 cc.xls

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s)  { return rtrim(ltrim(s)); }

# Usage :
#  iconv -f ISO-8859-1 -t UTF-8 lcl-test.xls | ./clean-lcl-csv.awk -v D=1	

# TODO faire sauter la dernière ligne avec "00670 017425B"
# Pas de type / tiers dépense

BEGIN {
 FS = "\t"
 TYPE_CHK = "Chèque"
 TYPE_CARD = "Carte"
 TYPE_TRANSFERT = "Virement"
 TYPE_DEBIT = "Prélèvement"

 PAYEE_TOTAL = "TOTAL OPTION SYSTEM' EPARGNE"
 PAYEE_TOTAL_BGN = "TOTAL OPTION SYSTEM"
 PAYEE_COTISATION = "COTISATION MENSUELLE CARTE"
 PAYEE_PRET = "PRET IMMOBILIER ECH"
 PAYEE_ASSURANCE = "ASSURANCE DECOUVERT AUTORISE"


 PAYEE_WITHDRAWAL = "CB  RETRAIT DU  "
 PAYEE_CARD =       "CB  "
 PAYEE_TRANSFERT = "PRLV "

 # DEBUG = 1 for debug
 if (D == "") {
   nOutLevel = 0
 } else {
   nOutLevel = D
 }


 printf "Date;Compte;Bénéficiaire;Montant;Catégorie;Mémo / Chq\n"
} ;

{
    valueDate = trim($1)
    amount = $2
    type = $3
    checkNum = $4
    payeeExpense = trim($5)
    payeeIncome = trim($6)
	
    tsnDate = valueDate
    tsnPayee = payeeExpense
    tsnMemo = ""

    check = 0

   # printf "analyse : .%s.\n", $0
    
    if ( (type == TYPE_CARD) &&  (index(payeeExpense, PAYEE_TOTAL_BGN) == 1) ) {
        tsnPayee = trim(payeeExpense)
        check = 1
    }

    #printf "index : %d type : %s\n", index(payeeExpense, PAYEE_WITHDRAWAL), type
    if ( (type == TYPE_CARD) &&  (index(payeeExpense, PAYEE_WITHDRAWAL) == 1) ) {
	dateBegin = substr(payeeExpense,length(payeeExpense)-4, 5);
	tsnPayee = "RETRAIT";
	tsnDate = dateBegin strftime("/%Y");
	check = 1;
			
    } 
    #printf "payee : %s\n", tsnPayee;

    # Check == 0 : because PAYEE_CARD & PAYEE_WITHDRAWAL start both start by PAYEE_CARD
    if ( (type == TYPE_CARD) &&  (index(payeeExpense, PAYEE_CARD) == 1)  && (check == 0)) {
	#printf "0 %s\n", payeeExpense
	tsnPayee = substr(payeeExpense, length(PAYEE_CARD)+1, length(payeeExpense)-10-length(PAYEE_CARD))
	#printf "1 %s du %s\n", tsnPayee, tsnDate
	tsnDate = substr(payeeExpense, length(payeeExpense)-7, 5)
	tsnDate = tsnDate strftime("/%Y")
		
	#tsnPayee = sub(/[ ]+$/,"", tsnPayee)
	tsnPayee=rtrim(tsnPayee)
	#printf "2 %s du %s\n", tsnPayee, tsnDate
	#printf "Carte pour %s \n", payeeExpense
	check = 1
    }

    if (type == TYPE_CHK) {
	tsnMemo = "#"checkNum
	tsnPayee = "CHEQUE A RENSEIGNER"
	check = 1
    }

    if (type == TYPE_TRANSFERT) {
	tsnPayee = trim(payeeExpense)
	check = 1
    }
    
    if (type == TYPE_DEBIT) {
	tsnPayee = trim(payeeExpense)
	check = 1
    }


    
    if (type == "") {
	if (payeeIncome != null) {
	#if (index(payeeIncome,PAYEE_COTISATION) == 1) {
	    tsnPayee = trim(payeeIncome)
	} else {
	    tsnPayee = trim(payeeExpense)
        }
	#if (amount >= 0) {
	#    tsnPayee = trim(payeeIncome)
	#}
	check = 1
    }

    
    if (check == 1) {
	#printf "processed : %s\n", $0;
	if (nOutLevel == 0) {
	  printf "%s;%s;%s;%s;%s;%s\n", tsnDate, "LCL CC", tsnPayee, amount, "", tsnMemo
	} else {
          printf "date: %s, montant: %s, tiers: %s, memo: %s, type: %s.\n", tsnDate, amount, tsnPayee, tsnMemo,type
        }
    } else {
	printf "unprocessed : %s\n", $0
        if (nOutLevel >= 1) {
	  printf "date valeur : %s", $1;
	  printf " / montant : %s", $2;
	  printf " / type : %s", $3;
	  printf " / #chèque : %s", $4;
	  printf " / bene- : %s", $5;
	  printf " / bene+ : %s", $6;
	  printf "\n"

       }
	
   }
}
