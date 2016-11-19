
; Load Parsing combinators
(load "pc.scm")
(load "parser.so")
; Symbol := <SymbolChar>+


; a-z A-Z 0-9
(define <digit-0-9>
	(range #\0 #\9))

(define <digit-1-9>
	(range #\1 #\9))

(define <a-z>
	(range #\a #\z))

(define <A-Z>
	(range #\A #\Z))

;any char but \ (do according to ascii table)
(define <StringLiteralChar>
	(new (*parser (char #\c))
		 (*pack-with
	     	(lambda (c)
	     		(if (not (equal? c (char #\\)))
	     			c
	     			(void))))
		done))

(define <StringMetaChar>
	(new (*parser (char #\\))
		 (*parser (char #\"))
		 (*parser (char #\t))
		 (*parser (char #\f))
		 (*parser (char #\n))
		 (*parser (char #\r))
		 (*disj 6)
		done))

(define <StringHexChar>
	(new (*parser (char #\\))
		 (*parser (char #\x))
		 (*parser (char #\space))
		 (*parser <HexChar>) *star
		 (*caten 4)
		done))

(define <StringChar>
	(new (*parser <StringLiteralChar>)
		 (*parser <StringMetaChar>)
		 (*parser <StringHexChar>)
		 (*disj 3)
		done))

(define <String>
	(new (*parser (char #\"))
		 (*parser <StringChar>) *star
		 (*parser (char #\"))
		 (*caten 3)
		done))

(define <SymbolNonLetter>
	(new (*parser (char #\!))
		 (*parser (char #\$))
		 (*parser (char #\^))
		 (*parser (char #\*))
		 (*parser (char #\-))
		 (*parser (char #\_))
		 (*parser (char #\=))
		 (*parser (char #\+))
		 (*parser (char #\<))
		 (*parser (char #\>))
		 (*parser (char #\?))
		 (*parser (char #\/))
		 (*disj 12)
		done))

(define <SymbolChar>
	(new (*parser <digit-0-9>)
		 (*parser <a-z>)
		 (*parser <A-Z>)
		 (*parser <SymbolNonLetter>)
		 (*disj 4)
		done))

(define <Symbol>
	(new (*parser <SymbolChar>)
		 (*parser <SymbolChar>) *star 
		 (*caten 2)
		done))

(define <ProperList>
	(new (*parser (char #\())
		 (*parser <Sexpr>) *star
		 (*parser (char #\)))
		 (*caten 3)
		done))

(define <ImproperList>
	(new (*parser (char #\())
		 (*parser <Sexpr>)
		 (*parser <Sexpr>) *star
		 (*caten 2)
		 (*parser (char #\space))
		 (*parser (char #\.))
		 (*parser (char #\space))
		 (*parser <Sexpr>)
		 (*parser (char #\)))
		 (*caten 7)
		done))

(define <Vector>
	(new (*parser (char #\#))
		 (*parser (char #\())
		 (*parser <Sexpr>) *star
		 (*parser (char #\)))
		 (*caten 4)
		done))

(define <Quoted>
	(new (*parser (char #\'))
		 (*parser <Sexpr>)
		 (*caten 2)
		done))

(define <QuasiQuoted>
	(new (*parser (char #\`))
		 (*parser <Sexpr>)
		 (*caten 2)
		done))

(define <Unquoted>
	(new (*parser (char #\,))
		 (*parser <Sexpr>)
		 (*caten 2)
		done))

(define <UnquoteAndSpliced>
	(new (*parser (char #\`))
		 (*parser (char #\@))
		 (*parser <Sexpr>)
		 (*caten 3)
		done))

;Testing
(display (test-string <Symbol> "l"))
(newline)
(display (test-string <Symbol> "K"))
(newline)
(display (test-string <Symbol> "1"))
(newline)
(display (test-string <Symbol> "0"))
(newline)
(display (test-string <Symbol> "="))
(newline)
(display (test-string <Symbol> "?"))
(newline)
(display (test-string <StringMetaChar> "\\"))
(newline)
(display (test-string <ProperList> "(+ 3 2)"))
(newline)
(display (test-string <ProperList> ""))
(newline)
(display (test-string <ImproperList> "((+ 3 2) . 4)"))
(newline)


(exit)

