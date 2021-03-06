-- |
-- Module      : Database.Relational.Query
-- Copyright   : 2013 Kei Hibino
-- License     : BSD3
--
-- Maintainer  : ex8k.hibino@gmail.com
-- Stability   : experimental
-- Portability : unknown
--
-- This module is integrated module of Query.
module Database.Relational.Query (
  module Database.Relational.Query.Table,
  module Database.Relational.Query.SQL,
  module Database.Relational.Query.Pure,
  module Database.Relational.Query.Pi,
  module Database.Relational.Query.Constraint,
  module Database.Relational.Query.Context,
  module Database.Relational.Query.Component,
  module Database.Relational.Query.Sub,
  module Database.Relational.Query.Projection,
  module Database.Relational.Query.Projectable,
  module Database.Relational.Query.ProjectableExtended,
  module Database.Relational.Query.Monad.Class,
  module Database.Relational.Query.Monad.Trans.Aggregating,
  module Database.Relational.Query.Monad.Trans.Ordering,
  module Database.Relational.Query.Monad.Trans.Assigning,
  module Database.Relational.Query.Monad.BaseType,
  module Database.Relational.Query.Monad.Type,
  module Database.Relational.Query.Monad.Simple,
  module Database.Relational.Query.Monad.Aggregate,
  module Database.Relational.Query.Monad.Unique,
  module Database.Relational.Query.Monad.Restrict,
  module Database.Relational.Query.Monad.Assign,
  module Database.Relational.Query.Relation,
  module Database.Relational.Query.Scalar,
  module Database.Relational.Query.Type,
  module Database.Relational.Query.Effect,
  module Database.Relational.Query.Derives
  ) where

import Database.Relational.Query.Table (Table, TableDerivable (..))
import Database.Relational.Query.SQL (updateOtherThanKeySQL, insertSQL)
import Database.Relational.Query.Pure
import Database.Relational.Query.Pi
import Database.Relational.Query.Constraint
  (Key, tableConstraint, projectionKey,
   uniqueKey, -- notNullKey,
   HasConstraintKey(constraintKey),
   derivedUniqueKey, -- derivedNotNullKey,
   Primary, Unique, NotNull)
import Database.Relational.Query.Context
import Database.Relational.Query.Component
  (NameConfig (..), Config (..), defaultConfig, ProductUnitSupport (..), Order (..))
import Database.Relational.Query.Sub (SubQuery, unitSQL, queryWidth)
import Database.Relational.Query.Projection (Projection, list)
import Database.Relational.Query.Projectable
import Database.Relational.Query.ProjectableExtended
import Database.Relational.Query.Monad.Class
  (MonadQualify,
   MonadRestrict, wheres, having, restrict,
   MonadAggregate, groupBy, groupBy',
   MonadQuery, query', queryMaybe',
   MonadPartition, partitionBy,
   distinct, all', on)
import Database.Relational.Query.Monad.Trans.Aggregating
  (key, key', set, bkey, rollup, cube, groupingSets)
import Database.Relational.Query.Monad.Trans.Ordering (orderBy, asc, desc)
import Database.Relational.Query.Monad.Trans.Assigning (assignTo, (<-#))
import Database.Relational.Query.Monad.BaseType
import Database.Relational.Query.Monad.Type
import Database.Relational.Query.Monad.Simple (QuerySimple, SimpleQuery)
import Database.Relational.Query.Monad.Aggregate
  (QueryAggregate, AggregatedQuery, Window, over)
import Database.Relational.Query.Monad.Unique (QueryUnique)
import Database.Relational.Query.Monad.Restrict (Restrict)
import Database.Relational.Query.Monad.Assign (Assign)
import Database.Relational.Query.Relation
import Database.Relational.Query.Scalar (ScalarDegree)
import Database.Relational.Query.Type hiding
  (unsafeTypedQuery, unsafeTypedKeyUpdate, unsafeTypedUpdate,
   unsafeTypedInsert, unsafeTypedInsertQuery, unsafeTypedDelete)
import Database.Relational.Query.Effect
import Database.Relational.Query.Derives

import Database.Record.Instances ()

{-# ANN module "HLint: ignore Use import/export shortcut" #-}
