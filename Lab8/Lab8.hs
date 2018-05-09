{- =========================
     --- EJERCICIO 1 (30)
   ========================= -}
--- !Definici¢n de funciones

--- A)
digit :: Char -> Bool
digit c = (c>='0') && (c<='9')
{- ===============================================================
!Dar una versión alternativa usando la función  ord :: Char -> Int
!que dado un caracter devuelve su codigo ascii.
=================================================================== -}


---   B)
uppercase :: Char -> Bool
uppercase c  = (c>='A') && (c<='Z')

lowercase :: Char -> Bool
lowercase c  = (c>='a') && (c<='z')

---    C)
letter :: Char -> Bool
letter c = lowercase c  || uppercase c


---    D)
charofdigit :: Int -> Char
charofdigit 0 = '0'
charofdigit 1 = '1'
charofdigit 2 = '2'
charofdigit 3 = '3'
charofdigit 4 = '4'
charofdigit 5 = '5'
charofdigit 6 = '6'
charofdigit 7 = '7'
charofdigit 8 = '8'
charofdigit 9 = '9'
{-===================================================================
    Dar una versión alternativa usando la función chr:: Int -> Char,
    ! que dado un codigo ascii nos devuelve el caracter que le corresponde
    ====================================================================-}



{- =========================
     --- EJERCICIO 2 (31)
   ========================= -}

 --- A)
among :: Eq alpha  => alpha  ->  [alpha] -> Bool
among x [] = False
among x (h:ts) = if x==h then True else among x ts

---------------

{- =====================================================================
!B) Con objeto de optimizar el test que debe relizar la funci¢n cu&&o trate con
!enteros negativos utilizaremos una funci¢n auxiliar que se encargara de reali-
!zar el proceso recursivo.El test solo se ejecutara una vez.
Esto puede hacerse definiendo la función auxiliar como una función local, us&&o
una expresión let o una cláusula where.
Observe que String (aunque predefinido en Haskell) es un renombramiento:
Type String = [Char]
======================================================================== -}

stringcopy :: Int -> String -> String
stringcopy n s  = if n<0 then (error "Numero negativo.")
                  else auxsc n s
                  where auxsc n s = if n==0 then [] else s ++ auxsc (n-1) s

--- Esta funci¢n puede mejorarse utiliz&&o pattern matching:
strcop :: Int  ->  String -> String
strcop n s = if n<0 then (error "Numero negativo.") else auxsc n s
auxsc n  []   = []
auxsc 0  s    = []
auxsc (n+1) s = s ++ auxsc n s



{- ====================================================================
     --- EJERCICIO 3 (32)
======================================================================= -}
data Valor = Uno | Dos | Tres | Cuatro | Cinco | Seis | Siete | Diez | Once | Doce
             deriving (Eq, Ord, Enum, Show)
data Palo  = Oros | Bastos | Copas | Espadas
             deriving (Eq, Ord, Enum, Show)
data Carta = Card Palo Valor

palode :: Carta -> Palo
palode (Card p v) = p

valorde :: Carta -> Valor
valorde (Card p v) = v

espalo :: Palo -> Carta -> Bool
espalo x (Card p v)  = (x==p)

esvalor :: Valor -> Carta -> Bool
esvalor x (Card p v) = (x==v)



{- ====================================================================
    --- EJERCICIO 4 (33)
======================================================================= -}
type Saco alpha  = [(alpha,Integer)]

add :: Eq alpha => alpha -> Saco alpha -> Saco alpha
add a [] = (a,1):[]
add a ((b,n):s) = if a==b then ((b,n+1):s) else ((b,n):(add a s))

remove :: Eq alpha => alpha  ->  Saco alpha -> (alpha, Saco alpha)
remove a [] = (a, [])
remove a ((b,n):s) = if b==a then (if n>1 then (b,((b,n-1):s)) else (b,s))
                             else let (aa, ss) = remove a s
                                      in (aa, ((b,n):ss))

isempty :: Saco alpha -> Bool
isempty [] = True
isempty (_:_) = False


saco = [('a',3), ('b', 2), ('c',1), ('d',5)]


{- ====================================================================
    --- EJERCICIO 5 (34)
======================================================================= -}

{- ==============================================================
 --- 0)
Reduction by higher-order functions

reduce ::   (alpha -> beta -> beta) ->    ! the reduction operation !
            beta                          ! the base case result    !
            [alpha]  ->                   ! the input list          !
            ->  beta                      ! the result type         !
================================================================= -}
reduce f  b  []   = b
reduce f  b  (n:l) = f  n (reduce f b l)


 --- A)
mapR f [] = []
mapR f (x:xs) = reduce (\y -> (\z -> (f y):z) ) [] (x:xs)

{- ==============================================================
La siguiente versión de map en términos de reduce es más truculenta. La función
nada no tiene ningún cometido, lo único que se requiere es una función
polimórfica de aridad 2 (podría valer cualquiera). Observe que, por definición
de la función reduce:

reduce nada (f x) [] = (f x)

con lo cual:
mapR2 f (x:xs) = ((reduce nada (f x) []) : (mapR2 f xs))
               = (f x):(mapR2 f xs)

que coincide con la definición clásica de map
================================================================= -}

nada x y = x

mapR2 f [] = []
mapR2 f (x:xs) = ((reduce nada (f x) []) : (mapR2 f xs))

appR [] xs = xs
appR (x:xs) ys = reduce (\u -> (\v -> u:v)) ys (x:xs)


 --- B)
amongR x [] = False
amongR x (y:ys) = reduce (\next -> (\isthea -> (if next == x then True else isthea)))  False (y:ys)

lambda = (\next -> (\isthea -> (if next == 8 then True else isthea)))

{- ====================================================================
    --- EJERCICIO 6 (35)

Definir una función uncurry que tome una función de curry de tipo
alpha -> beta -> gamma y la convierta en una función de tipo (alpha, beta) -> gamma, sin currificar.

======================================================================= -}

uncurry f (x,y) = f x y



{-======================================================================= -}

from x = x : from (x+1)
