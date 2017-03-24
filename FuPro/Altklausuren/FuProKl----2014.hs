{-# LANGUAGE LambdaCase #-}
module FuProKl2014 where
import Data.Maybe

--A1
--1.
a1a :: ([Integer], a) -> [Integer]
a1a = map (\x -> x + 1) .fst

a1b :: Maybe (a -> Bool) -> [a] -> Bool
a1b (Just f) (x:xs) = (f x) && (a1b (Just f) xs)
a1b _        _      = True

--2.
a2 = map (\(x,y) -> x + y) $ zip [0,1..] [1..4]
-- map (\(x,y) -> x + y) [(0,1),(1,2),(2,3),(3,4)]
-- 1 : map (\(x,y) -> x + y) [(1,2),(2,3),(3,4)]
-- 1 : 3 : 5 : 7 : []
-- [1,3,5,7]

--1.
data Either a b = Left a 
                | Right b
data D a b = C b (a Int) b

--a)
--
--Either [Int] :: * -> *
--
-- D :: (* -> *) -> * -> *


--A2

insert :: Ord a => a -> [a] -> [a]
insert a ls = case ls of
    []      -> [a]
    (b:bs)  -> if (a > b) then b : insert a bs else a:(b:bs)

concat' :: [[a]] -> [a]
concat' []      = []
concat' (a:as) = a ++ concat' as

--A3

data Bintree a  = Empty
                | Fork a (Bintree a) (Bintree a)

--1.
preorder :: Ord a => Bintree a -> [a]
preorder = \case
    Empty         -> []
    (Fork a l r)  -> a : preorder l ++ preorder r

--2.
zipTree :: Bintree a -> Bintree b -> Bintree (a,b)
zipTree Empty           _               = Empty
zipTree _               Empty           = Empty
zipTree (Fork a1 l1 r1) (Fork a2 l2 r2) = Fork (a1, a2) 
                                            (zipTree l1 l2) 
                                            (zipTree r1 r2)

--3.
instance Functor Bintree where
    fmap _ Empty        = Empty
    fmap f (Fork a l r) = Fork (f a) (fmap f l) (fmap f r)

--4.
isBinSearchTree :: Ord a => Bintree a -> Bool
isBinSearchTree = \case
    Empty        -> True
    (Fork a l r) -> lSmallerR l r 
                    && isBinSearchTree l 
                    && isBinSearchTree r
    where
    lSmallerR Empty           Empty        = True
    lSmallerR (Fork a _ _)    (Fork b _ _) = a < b
    lSmallerR _               _            = True

--A4
data Exp    = Const Int
            | Var Char
            | Negation Exp
            | Sum Exp Exp
            | Product Exp Exp

eval1 :: Exp -> (Char -> Maybe Int) -> Maybe Int

--1.
eval1 exp f = case noNothing exp f of
                True  -> myEval exp f
                False -> Nothing
    where
    noNothing exp f = case exp of
        (Var c)         -> if isJust (f c) then True else False
        (Const i)       -> True
        Negation e      -> noNothing e f
        Sum e1 e2       -> noNothing e1 f && noNothing e2 f
        Product e1 e2   -> noNothing e1 f && noNothing e2 f

    myEval (Var c)         f = f c
    myEval (Const i)       _ = Just i
    myEval (Negation e)    _ = fmap (*(-1)) e
    myEval (Sum e1 e2)     _ = fmap (+) e1 e2
    myEval (Product e1 e2) _ = fmap (*) e1 e2
