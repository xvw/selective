{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE StandaloneDeriving, DerivingVia #-}
{-# LANGUAGE FlexibleInstances, TupleSections, ExplicitForAll #-}

import Prelude hiding (maybe)
import Test.Tasty
import Test.Tasty.QuickCheck as QC
import Test.QuickCheck.Checkers as Check
import Test.QuickCheck.Checkers (EqProp)
import Test.QuickCheck.Classes as Check
import Test.Tasty.ExpectedFailure
import Control.Selective
import Control.Arrow
import Laws

check :: IO ()
check = defaultMain $ testGroup "Arrows instances"
    []

-----
-- Arrow laws as QuickCheck properties
-----
-- | Most of the properties Checkers provide require triples as arguments for the reason that is yet
-- unclear to me. This dummy value is handy to use with -XTypeApplication, like this: labrat @Maybe.
-- Checkers.T is a type alias for Char.
labrat :: f (Checkers.T, Checkers.T, Checkers.T)
labrat = undefined

functorLawsMaybe = Checkers.verboseBatch (Checkers.functor (labrat @Maybe))

instance Eq m => EqProp (Over m a) where
    (Over m1) =-= (Over m2) = Checkers.eq m1 m2

-- | Silly Monad instance for 'Over String', used for sanity check of
--   'Checkers.monad'.
instance Monad (Over String) where
    (Over m) >>= f = Over "c"

-- | Will fail, since the the provided Monad instance in lawless.
monadLawsOver = Checkers.verboseBatch (Checkers.monad (labrat @(Over String)))

functorLawsOver = Checkers.verboseBatch (Checkers.functor (undefined :: Over String Labrat))

applicativeLawsOver = Checkers.verboseBatch (Checkers.applicative (undefined :: Over String Labrat))

arrowLawsArrow = Checkers.verboseBatch (Checkers.arrow (labrat @((->) Int)))