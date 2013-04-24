{-# LANGUAGE OverloadedStrings #-}

-- |
-- Module      : Language.SQL.Keyword
-- Copyright   : 2013 Kei Hibino
-- License     : BSD3
--
-- Maintainer  : ex8k.hibino@gmail.com
-- Stability   : experimental
-- Portability : unknown
module Language.SQL.Keyword (
  Keyword (..),

  word,
  wordShow, unwordsSQL,

  sepBy, parenSepBy, defineBinOp,
  as, (<.>),

  (<=>), (<<>>), and, or,

  stringMap
  ) where

import Prelude hiding (and, or)
import Data.String (IsString(fromString))
import Data.List (find, intersperse)


data Keyword = SELECT | ALL | DISTINCT | ON
             | GROUP | COUNT | SUM | AVG | MAX | MIN
             | ORDER | BY | ASC | DESC
             | FETCH | FIRST | NEXT | ROW | ROWS | ONLY

             | DELETE | USING | RETURNING

             | FROM | AS | WITH
             | JOIN | INNER | LEFT | RIGHT | FULL | NATURAL | OUTER

             | UPDATE | SET | DEFAULT

             | WHERE

             | INSERT | INTO | VALUES

             | CASE | END | WHEN | ELSE | THEN

             | LIKE
             -- | (:?)
             -- | (:=) | (:<) | (:<=)| (:>) | (:>=) | (:<>)
             -- | (:+) | (:-) | (:*) | (:/) | (:||)
             | AND | OR | NOT

             | IS | NULL

             -- | OPEN | CLOSE

             | Sequence String
             deriving (Read, Show)


instance IsString Keyword where
  fromString s' = found (find ((== "") . snd) (reads s')) s'  where
   found  Nothing      s = Sequence s
   found (Just (w, _)) _ = w

word :: String -> Keyword
word =  Sequence

wordShow :: Keyword -> String
wordShow =  d  where
  d (Sequence s)   = s
  d w              = show w

sepBy' :: [Keyword] -> Keyword -> [String]
ws `sepBy'` d =  map wordShow . intersperse d $ ws

unwordsSQL :: [Keyword] -> String
unwordsSQL =  unwords . map wordShow

-- unwords' :: [Keyword] -> Keyword
-- unwords' =  word . unwordsSQL

concat' :: [String] -> Keyword
concat' =  word . concat

sepBy :: [Keyword] -> Keyword -> Keyword
ws `sepBy` d = concat' $ ws `sepBy'` d

parenSepBy :: [Keyword] -> Keyword -> Keyword
ws `parenSepBy` d = concat' $ "(" : (ws `sepBy'` d) ++ [")"]

defineBinOp' :: Keyword -> Keyword -> Keyword -> Keyword
defineBinOp' op a b = concat' $ [a, b] `sepBy'` op

defineBinOp :: Keyword -> Keyword -> Keyword -> Keyword
defineBinOp op a b = word . unwords $ [a, b] `sepBy'` op

as :: Keyword -> Keyword -> Keyword
as =  defineBinOp AS

(<.>) :: Keyword -> Keyword -> Keyword
(<.>) =  defineBinOp' "."

(<=>) :: Keyword -> Keyword -> Keyword
(<=>) =  defineBinOp "="

(<<>>) :: Keyword -> Keyword -> Keyword
(<<>>) =  defineBinOp "<>"

and :: Keyword -> Keyword -> Keyword
and =  defineBinOp AND

or :: Keyword -> Keyword -> Keyword
or =  defineBinOp OR

infixl 4 `and`
infixl 3 `or`
infixl 2 <=>, <<>>


stringMap :: (String -> String) -> Keyword -> Keyword
stringMap f = word . f . wordShow