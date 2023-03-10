-- | A module implementing Erlang sets as created by the `sets` module with `{version, 2}`.
module Erl.Data.Set
  ( Set
  , fromFoldable
  , empty
  , isEmpty
  , singleton
  , toUnfoldable
  , toList
  , fromList
  , union
  , unions
  , insert
  , delete
  , filter
  , difference
  , intersection
  , member
  ) where

import Prelude

import Data.Foldable (class Foldable)
import Data.Unfoldable (class Unfoldable)
import Erl.Data.List (List, nil, (:))
import Erl.Data.List as List
import Test.QuickCheck (class Arbitrary, arbitrary)

-- | An Erlang set as created by the `sets` module with the `{version, 2}` option passed.
foreign import data Set :: Type -> Type

instance eqSet :: Eq a => Eq (Set a) where
  eq set1 set2 = eq_ set1 set2

instance showSet :: Show a => Show (Set a) where
  show set = "fromFoldable " <> show (toUnfoldable set :: Array a)

instance arbitrarySet :: (Arbitrary a, Eq a) => Arbitrary (Set a) where
  arbitrary = do
    (xs :: Array a) <- arbitrary
    xs # fromFoldable # pure

instance semigroupSet :: Semigroup (Set a) where
  append s1 s2 = union s1 s2

instance monoidSet :: Monoid (Set a) where
  mempty = empty

instance functorSet :: Functor Set where
  map f s = s # toList # map f # fromList

-- | Creates an empty set with `{version, 2}`.
empty :: forall a. Set a
empty = empty_

-- | Tests if a set is empty.
isEmpty :: forall a. Set a -> Boolean
isEmpty s = isEmpty_ s

-- | Creates a set with one element.
singleton :: forall a. a -> Set a
singleton a = singleton_ a

-- | Creates a set from a list.
fromList :: forall a. List a -> Set a
fromList l = fromList_ l

-- | Creates a list from a set.
toList :: forall a. Set a -> List a
toList s = toList_ s

-- | Creates the union of two sets.
union :: forall a. Set a -> Set a -> Set a
union s1 s2 = union_ (s1 : s2 : nil)

-- | Creates the union of all sets in a list.
unions :: forall a. List (Set a) -> Set a
unions sets = union_ sets

-- | Adds an element to a set.
insert :: forall a. a -> Set a -> Set a
insert a s = insert_ a s

-- | Removes an element from a set.
delete :: forall a. a -> Set a -> Set a
delete a s = delete_ a s

-- | Filters a set, creating a new set whith all elements that satisfy the supplied predicate.
filter :: forall a. (a -> Boolean) -> Set a -> Set a
filter p s = s # toList # List.filter p # fromList

-- | Creates a set with all elements in `s2` that are not in `s1`.
difference :: forall a. Set a -> Set a -> Set a
difference s1 s2 = difference_ s1 s2

-- | Checks if an element is in a set.
member :: forall a. a -> Set a -> Boolean
member a s = member_ a s

-- | Creates a set from the intersection of two sets.
intersection :: forall a. Set a -> Set a -> Set a
intersection s1 s2 = intersection_ s1 s2

fromFoldable :: forall f a. Foldable f => f a -> Set a
fromFoldable = List.fromFoldable >>> fromList_

toUnfoldable :: forall f a. Unfoldable f => Set a -> f a
toUnfoldable = toList >>> List.toUnfoldable

foreign import fromList_ :: forall a. List a -> Set a

foreign import empty_ :: forall a. Set a

foreign import isEmpty_ :: forall a. Set a -> Boolean

foreign import singleton_ :: forall a. a -> Set a

foreign import toList_ :: forall a. Set a -> List a

foreign import eq_ :: forall a. Set a -> Set a -> Boolean

foreign import union_ :: forall a. List (Set a) -> Set a

foreign import insert_ :: forall a. a -> Set a -> Set a

foreign import delete_ :: forall a. a -> Set a -> Set a

foreign import difference_ :: forall a. Set a -> Set a -> Set a

foreign import intersection_ :: forall a. Set a -> Set a -> Set a

foreign import member_ :: forall a. a -> Set a -> Boolean
