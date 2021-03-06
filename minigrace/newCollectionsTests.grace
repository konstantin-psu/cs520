import "gUnit" as gU
//import "newCollections" as collections
//
//type Block0<R> = collections.Block0<R>
//type Block1<T,R> = collections.Block1<T,R>
//type Block2<S,T,R> = collections.Block1<T,R>
//
//type Collection<T> = collections.Collection<T>
//type Binding<K,T> = collections.Binding<K,T>
//type Iterator<T> = collections.Iterator<T>
//type CollectionFactory<T> = collections.CollectionFactory<T>
//type EmptyCollectionFactory<T> = collections.EmptyCollectionFactory<T>
//type Enumerable<T> = collections.Enumerable<T>
//type Sequence<T> = collections.Sequence<T>
//type List<T> = collections.List<T>
//type Set<T> = collections.Set<T>
//type Dictionary<K, T> = collections.Dictionary<K, T>
//
//def BoundsError is public = collections.BoundsError
//def Exhausted is public = collections.Exhausted
//def NoSuchObject is public = collections.NoSuchObject
//def RequestError is public = collections.RequestError
//def SubobjectResponsibility is public = collections.SubobjectResponsibility
//
//def collectionFactory is public = collections.collectionFactory
//def lazySequence is public = collections.lazySequence
//def collection is public = collections.collection
//def sequence is public = collections.sequence
//def list is public = collections.list
//def set is public = collections.set
//def dictionary is public = collections.dictionary
//def binding is public = collections.binding
//def range is public = collections.range


def bindingTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)

        method testStringification {
            assert ((2::4).asString) shouldBe "2::4"
        }
        method testBindingEquality {
            assert ((2::4) == (2::4)) description "2::4 is not equal to itself!"
        }
        method testBindingInequalityValue {
            deny ((2::4) == (2::5)) description "2::4 is equal to 2::5!"
        }
        method testBindingInequalityKey {
            deny ((2::4) == (1::4)) description "2::4 is equal to 1::4!"
        }
        method testBindingInequalityKind {
            deny ((2::4) == "two") description "2::4 is equal to \"two\""
        }
        method testExtractFields {
            def b = "one"::1
            assert (b.key) shouldBe "one"
            assert (b.value) shouldBe 1
        }
    }
}

def rangeTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)
        
        def rangeUp = range.from 3 to 6
        def rangeDown = range.from 10 downTo 7
        def emptyUp = range.from 5 to 4
        def emptyDown = range.from 7 downTo 8
        def singleUp = range.from 4 to 4
        def singleDown = range.from 7 downTo 7

        method testRangeTypeCollection {
            def witness = range.from 1 to 6
            assert (witness) hasType (Collection<Number>)
        }
        method testRangeTypeSequence {
            def witness = range.from 1 to 6
            assert (witness) hasType (Sequence<Number>)
        }
        method testRangeTypeEnumerable {
            def witness = range.from 1 to 6
            assert (witness) hasType (Enumerable<Number>)
        }
        method testRangeTypeNotTypeWithWombat {
            def witness = range.from 1 to 6
            deny (witness) hasType (Collection<Number> & type { wombat })
        }


        method testRangePreconditionUp1 {
            assert {range.from 4.5 to 5} shouldRaise (RequestError)
        }
        
        method testRangePreconditionUp2 {
            assert {range.from 4 to 9.5} shouldRaise (RequestError)
        }
        
        method testRangePreconditionUp3 {
            assert {range.from 4 to "foo"} shouldRaise (RequestError)
        }
            
        method testRangePreconditionDown1 {
            assert {range.from 4 downTo 1.5} shouldRaise (RequestError)
        }

        method testRangePreconditionDown2 {
            assert {range.from 4 downTo 1.5} shouldRaise (RequestError)
        }
                    
        method testRangePreconditionDown3 {
            assert {range.from 4.5 downTo "foo"} shouldRaise (RequestError)
        }

        method testRangeSizesUp {
            assert (rangeUp.size) shouldBe (4)
            assert (emptyUp.size) shouldBe (0)
            assert (singleUp.size) shouldBe (1)
        }
        method testRangeSizesDown {
            assert (rangeDown.size) shouldBe (4)
            assert (emptyDown.size) shouldBe (0)
            assert (singleDown.size) shouldBe (1)
        }
        method testRangeUpContainsIn {
            assert (rangeUp.contains 3) description "{rangeUp} doesn't contain 3"
            assert (rangeUp.contains 4) description "{rangeUp} doesn't contain 4"
            assert (rangeUp.contains 5) description "{rangeUp} doesn't contain 5"
            assert (rangeUp.contains 6) description "{rangeUp} doesn't contain 6"
        }
        method testRangeUpContainsOut {
            deny (rangeUp.contains 2) description "{rangeUp} contains 2"
            deny (rangeUp.contains 7) description "{rangeUp} contains 7"
            deny (rangeUp.contains 5.5) description "{rangeUp} contains 5.5"
            deny (rangeUp.contains "foo") description "{rangeUp} contains \"foo\""
        }
        method testRangeElementsUp {
            def elements = list.empty 
            for (rangeUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(3, 4, 5, 6))
            assert (rangeUp.asList) shouldBe (list.with(3, 4, 5, 6))
        }    
        method testRangeElementsUpWithFold {
            def elements = rangeUp.fold {acc, each -> acc.add(each)} 
                startingWith (list.empty)
            assert (elements) shouldBe (list.with(3, 4, 5, 6))
        }
        method testRangeUpFold {
            def sum = rangeUp.fold {acc, each -> acc + each} startingWith 0
            assert (sum) shouldBe 18
        }
        method testRangeDownContainsIn {
            assert (rangeDown.contains 10) description "{rangeDown} doesn't contain 10"
            assert (rangeDown.contains 9) description "{rangeDown} doesn't contain 9"
            assert (rangeDown.contains 8) description "{rangeDown} doesn't contain 8"
            assert (rangeDown.contains 7) description "{rangeDown} doesn't contain 7"
        }
        method testRangeDownContainsOut {
            deny (rangeDown.contains 6) description "{rangeDown} contains 6"
            deny (rangeDown.contains 11) description "{rangeDown} contains 11"
            deny (rangeDown.contains 5.5) description "{rangeDown} contains 5.5"
            deny (rangeDown.contains "foo") description "{rangeDown} contains \"foo\""
        }

        method testRangeElementsDown {
            def elements = list.empty 
            for (rangeDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(10, 9, 8, 7))
        }
        method testRangeElementsEmptyUp {
            def elements = list.empty 
            for (emptyUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.empty)
        }
        method testRangeElementsEmptyDown {
            def elements = list.empty 
            for (emptyDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.empty)
        }
        method testRangeElementsSingletonUp {
            def elements = list.empty 
            for (singleUp) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(4))
        }
        method testRangeElementsSingletonDown {
            def elements = list.empty 
            for (singleDown) do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(7))
        }
        method testRangeElementsDoUp {
            def elements = list.empty 
            (rangeUp).do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(3, 4, 5, 6))
        }
        method testRangeKeysAndValues {
            var s := ""
            rangeUp.keysAndValuesDo { k, v -> s := s ++ "{k}::{v} " }
            assert (s) shouldBe "1::3 2::4 3::5 4::6 "
        }
        method testRangeUpKeysAndValuesEmpty {
            var s := ""
            emptyUp.keysAndValuesDo { k, v -> s := s ++ "{k}::{v} " }
            assert (s) shouldBe ""
        }
        method testRangeElementsDoDown {
            def elements = list.empty 
            (rangeDown).do {each -> elements.add(each)}
            assert (elements) shouldBe (list.with(10, 9, 8, 7))
        } 
        method testRangeKeysAndValuesDown {
            var s := ""
            rangeDown.keysAndValuesDo { k, v -> s := s ++ "{k}::{v} " }
            assert (s) shouldBe "1::10 2::9 3::8 4::7 "
        }
        method testRangeDownKeysAndValuesEmpty {
            var s := ""
            emptyDown.keysAndValuesDo { k, v -> s := s ++ "{k}::{v} " }
            assert (s) shouldBe ""
        }
        method testRangeUpReverse {
            assert (rangeUp.reversed) shouldBe (range.from(6)downTo(3))
        }
        method testRangeFilterExhausted {
            def rangeFiltered = rangeUp.filter{each -> each > 10}
            def rangeFilteredIterator = rangeFiltered.iterator
            assert(rangeFilteredIterator) hasType (Iterator)
            deny(rangeFilteredIterator.hasNext) description "empty rangeFilteredIterator hasNext!"
            assert{rangeFilteredIterator.next} shouldRaise (Exhausted)
        }
        method testRangeFilterEmptyList {
            assert (rangeUp.filter{each -> each > 10}.onto(list)) shouldBe (list.empty)
        }
        method testRangeFilterEmpty {
            assert (rangeUp.filter{each -> each > 10}.isEmpty) 
                description "range filter by an everywhere-false predicate isn't empty"
        }
        method testRangeDownReverse {
            assert (rangeDown.reversed) shouldBe (range.from(7)to(10))
        }
        method testRangeEqualityWithList {
            assert(rangeDown == list.with(10,9,8,7)) 
                description "range.from 10 downTo 7 ≠ list.with(10, 9, 8 ,7)"
            assert(emptyUp == list.empty) 
                description "The empty range was not equal to the empty list"
        }
        method testRangeInequalityWithNumber {
            deny(rangeDown == 7) description ("rangeDown == 7")
        }
        method testRangeInequalityWithList {
            assert(rangeDown != []) description("Failed trying the empty list")
            assert(rangeDown != [3,4,5]) 
                description("Range = list with a different size.")
            assert(rangeDown != [10,9,8,5]) 
                description("Range = list with different contents")
        }
        method testRangeUpListConversion {
            assert(rangeUp.asList == list.with(3,4,5,6))
            assert(rangeUp.asList) hasType (List)
        }
        method testRangeUpSequenceConversion {
            assert(rangeUp.asSequence == sequence.with(3,4,5,6))
            assert(rangeUp.asSequence) hasType (Sequence)
        }
        method testRangeDownListConversion {
            assert(rangeDown.asList == list.with(10,9,8,7))
            assert(rangeDown.asList) hasType (List)
        }
        method testRangeDownSequenceConversion {
            assert(rangeDown.asSequence == sequence.with(10,9,8,7))
            assert(rangeDown.asSequence) hasType (Sequence)
        }
        method testRangeDownAt {
            assert(rangeDown.at(1)) shouldBe 10
            assert(rangeDown.at(2)) shouldBe 9
            assert(rangeDown.at(3)) shouldBe 8
            assert(rangeDown.at(4)) shouldBe 7
            assert{rangeDown.at(5)} shouldRaise (BoundsError)
            assert{rangeDown.at(0)} shouldRaise (BoundsError)
        }
        method testRangeUpAt {
            assert(rangeUp.at(1)) shouldBe 3
            assert(rangeUp.at(2)) shouldBe 4
            assert(rangeUp.at(3)) shouldBe 5
            assert(rangeUp.at(4)) shouldBe 6
            assert{rangeUp.at(5)} shouldRaise (BoundsError)
            assert{rangeUp.at(0)} shouldRaise (BoundsError)
        }
        method testRangeUpAsDictionary {
            assert(rangeUp.asDictionary) shouldBe 
                (dictionary.with(1::3, 2::4, 3::5, 4::6))
        }
        method testRangeDownAsDictionary {
            assert(rangeDown.asDictionary) shouldBe
                (dictionary.with(1::10, 2::9, 3::8, 4::7))
        }
    }
}

def sequenceTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)

        def oneToFive = sequence.with(1, 2, 3, 4, 5)
        def evens = sequence.with(2, 4, 6, 8)
        def empty = sequence.empty

        method testSequenceTypeCollection {
            def witness = sequence<Number>.with(1,3)
            assert (witness) hasType (Collection<Number>)
        }
        method testSequenceTypeSequence {
            def witness = sequence<Number>.with(1,3)
            assert (witness) hasType (Sequence<Number>)
        }
        method testSequenceTypeEnumerable {
            def witness = sequence<Number>.with(1,3)
            assert (witness) hasType (Enumerable<Number>)
        }
        method testFilteredSequenceTypeEnumerable {
            def witness = sequence<Number>.with(1,3).filter{x -> true}
            assert (witness) hasType (Enumerable<Number>)
        }
        method testSequenceNotTypeWithWombat {
            def witness = sequence<Number>.with(1,3)
            deny (witness) hasType (Collection<Number> & type { wombat })
        }
        method testSequenceSize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }
        
        method testSequenceEmptyDo {
            empty.do {each -> failBecause "emptySequence.do did with {each}"}
        }
        
        method testSequenceEqualityEmpty {
            assert(empty == sequence.empty) description "empty sequence ≠ itself!"
            assert(empty == list.empty) description "empty sequence ≠ empty list"
        }
        
        method testSequenceInequalityEmpty {
            deny(empty == sequence.with(1))
            assert(empty != sequence.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }
        
        method testSequenceInequalityFive {
            deny(oneToFive == sequence.with(1, 2, 3, 4, 6))
            assert(oneToFive != sequence.with(1, 2, 3, 4, 6))
        }

        method testSequenceEqualityFive {
            def isEqual = (oneToFive == sequence.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != sequence.with(1, 2, 3, 4, 5))
        }

        method testSequenceOneToFiveDo {
            var element := 1
            oneToFive.do { each -> 
                assert (each) shouldBe (element)
                element := element + 1
            }
        }
        method testSequenceContains {
            assert (oneToFive.contains(1)) description "oneToFive does not contain 1"
            assert (oneToFive.contains(5)) description "oneToFive does not contain 5"
            deny (oneToFive.contains(0)) description "oneToFive contains 0"
            deny (oneToFive.contains(6)) description "oneToFive contains 6"
        }
        
        method testSequenceFirst {
            assert{empty.first} shouldRaise (BoundsError)
            assert(evens.first) shouldBe (2)
            assert(oneToFive.first) shouldBe (1)
        }
        
        method testSequenceAt {
            assert {empty.at(1)} shouldRaise (BoundsError)
            assert (oneToFive.at(1)) shouldBe (1)
            assert (oneToFive[1]) shouldBe (1)
            assert (oneToFive.at(5)) shouldBe (5)
            assert (evens.at(4)) shouldBe (8)
            assert {evens.at(5)} shouldRaise (BoundsError)
        }
        
        method testSequenceOrdinals {
            assert {empty.first} shouldRaise (BoundsError)
            assert (oneToFive.first) shouldBe (1)
            assert (oneToFive.second) shouldBe (2)
            assert (oneToFive.third) shouldBe (3)
            assert (evens.fourth) shouldBe (8)
            assert {evens.fifth} shouldRaise (BoundsError)
        }

        method testSequenceConcatWithEmpty {
            assert(empty ++ oneToFive)shouldBe(oneToFive)        
            assert(oneToFive ++ empty)shouldBe(oneToFive)
        }
        
        method testSequenceConcatWithNonEmpty {
            assert(oneToFive ++ evens) shouldBe(sequence.with(1, 2, 3, 4, 5, 2, 4, 6, 8))
            assert(evens ++ oneToFive) shouldBe(sequence.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }

        method testSequenceIndicesAndKeys {
            def seq = oneToFive ++ evens
            def totalSize = oneToFive.size + evens.size
            assert (seq.indices) shouldBe (1..totalSize)
            assert (seq.indices) shouldBe (seq.keys)
        }
        
        method testSequenceFold {
            assert(oneToFive.fold{a, each -> a + each}startingWith(0))shouldBe(15)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)        
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }
        
        method testSequenceDoSeparatedBy {
            var s := ""
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert (s) shouldBe ("2, 4, 6, 8")
        }
        
        method testSequenceDoSeparatedByEmpty {
            var s := "nothing"
            empty.do { failBecause "do did when sequence is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testSequenceDoSeparatedBySingleton {
            var s := "nothing"
            sequence.with(1).do { each -> assert(each)shouldBe(1) } 
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
                
        method testSequenceKeysAndValuesDo {
            def accum = dictionary.empty
            var n := 1
            evens.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (dictionary.with(1::2, 2::4, 3::6, 4::8))
        }
        
        method testSequenceReversedOneToFive {
            assert (oneToFive.reversed) shouldBe (sequence.with(5, 4, 3, 2, 1))
        }
        
        method testSequenceReversedEvens {
            assert (evens.reversed) shouldBe (sequence.with(8, 6, 4, 2))
            assert (evens.reversed.reversed) shouldBe (evens)
        }
        
        method testSequenceReversedEmpty {
            assert (empty.reversed) shouldBe (empty)
        }

        method testSequenceAsStringNonEmpty {
            assert (evens.asString) shouldBe ("⟨2, 4, 6, 8⟩")
        }
             
        method testSequenceAsStringEmpty {
            assert (empty.asString) shouldBe ("⟨⟩")
        }
        
        method testSequenceMapEmpty {
            assert (empty.map{x -> x * x}.onto(list)) shouldBe (list.empty)
        }
        
        method testSequenceMapEvens {
            assert(evens.map{x -> x + 1}.onto(list)) shouldBe (list.with(3, 5, 7, 9))
        }
        
        method testSequenceMapEvensInto {
            assert(evens.map{x -> x + 10}.into(list.withAll(evens)))
                shouldBe (list.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        method testSequenceFilterNone {
            deny(oneToFive.filter{x -> false}.iterator.hasNext)
        }
        
        method testSequenceFilterEmpty {
            assert(empty.filter{x -> (x % 2) == 1}.isEmpty)
        }

        method testSequenceFilterOdd {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(list))
                shouldBe (list.with(1, 3, 5))
        }
        
        method testSequenceMapAndFilter {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(list))
                shouldBe (list.with(11, 13, 15))
        }
        
        method testSequenceToList1to5 {
            assert (oneToFive.asList) shouldBe (list.with(1, 2, 3, 4, 5))
            assert (oneToFive.asList) hasType (List)
        }
        
        method testSequenceToListEmpty {
            assert (empty.asList) shouldBe (list.empty)
            assert (empty.asList) hasType (List)
        }

        method testSequenceToSet1to5 {
            assert (oneToFive.asSet) shouldBe (set.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSet) hasType (Set)
        }
        
        method testSequenceToSetEmpty {
            assert (empty.asSet) shouldBe (set.empty)
            assert (empty.asSet) hasType (Set)
        }
        method testSequenceToSetDuplicates {
            def theSet = sequence.with(1,1,2,2,4).asSet
            assert (theSet) shouldBe (set.with(1, 2, 4))
            assert (theSet) hasType (Set)
        }
        method testSequenceIteratorEmpty {
            deny (empty.iterator.hasNext)
                description "empty iterator has an element"
        }
        method testSequenceIteratorNonEmpty {
            def accum = set.empty
            def iter = oneToFive.iterator
            while {iter.hasNext} do { accum.add(iter.next) }
            assert (accum) shouldBe (set.with(1, 2, 3, 4, 5))
        }
        method testSequenceIteratorToSetDuplicates {
            def accum = set.empty
            def iter = sequence.with(1, 1, 2, 2, 4).iterator
            while {iter.hasNext} do { accum.add(iter.next) }
            assert (accum) shouldBe (set.with(1, 2, 4))
        }
        method testSequenceSorted {
            def input = sequence.with(5, 3, 11, 7, 2)
            def output = input.sorted
            assert (output) shouldBe (sequence.with(2, 3, 5, 7, 11))
            assert (output.asString.startsWith (sequence.empty.asString.first)) description
                ".sorted does not look like a sequence"
            assert (output) hasType (Sequence)
        }
        method testSequenceSortedBy {
            def input = sequence.with(5, 3, 11, 7, 2)
            def output = input.sortedBy {l, r -> 
                if (l == r) then {0}
                    elseif (l < r) then {1}
                    else {-1}
                }
            assert (input) shouldBe (sequence.with(5, 3, 11, 7, 2))
            assert (output) shouldBe (sequence.with(11, 7, 5, 3, 2))
            assert (output.asString.startsWith (sequence.empty.asString.first)) description
                "sorted does not look like a sequence"
            assert (output) hasType (Sequence)
        }
        method testSequenceAsDictionary {
            assert(evens.asDictionary) shouldBe
                (dictionary.with(1::2, 2::4, 3::6, 4::8))
        }
        method lazyConcat {
            def s1 = oneToFive.filter{x -> (x % 2) == 1}
            def s2 = evens.filter{x -> true}
            assert(s1 ++ s2) shouldBe (sequence.with(1, 3, 5, 2, 4, 6, 8))
        }
    }
}

def listTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)

        def oneToFive = list.with(1, 2, 3, 4, 5)
        def evens = list.with(2, 4, 6, 8)
        def empty = list.empty

        method testListTypeCollection {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (Collection<Number>)
        }
        method testListTypeList {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (List<Number>)
        }
        method testListTypeSequence {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            assert (witness) hasType (Sequence<Number>)
        }
        method testListTypeNotTypeWithWombat {
            def witness = list<Number>.with(1, 2, 3, 4, 5, 6)
            deny (witness) hasType (List<Number> & type { wombat })
        }

        method testListSize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }
        
        method testListEmptyDo {
            empty.do {each -> failBecause "emptyList.do did with {each}"}
        }
        
        method testListEqualityEmpty {
            assert(empty == list.empty) description "empty list ≠ itself!"
            assert(empty == sequence.empty) description "empty list ≠ empty sequence"
        }
        
        method testListInequalityEmpty {
            deny(empty == list.with(1))
            assert(empty != list.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }
        
        method testListInequalityFive {
            deny(oneToFive == list.with(1, 2, 3, 4, 6))
            assert(oneToFive != list.with(1, 2, 3, 4, 6))
        }

        method testListEqualityFive {
            def isEqual = (oneToFive == list.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != list.with(1, 2, 3, 4, 5))
        }

        method testListOneToFiveDo {
            var element := 1
            oneToFive.do { each -> 
                assert (each) shouldBe (element)
                element := element + 1
            }
        }
        method testListContains {
            assert (oneToFive.contains(1)) description "oneToFive does not contain 1"
            assert (oneToFive.contains(5)) description "oneToFive does not contain 5"
            deny (oneToFive.contains(0)) description "oneToFive contains 0"
            deny (oneToFive.contains(6)) description "oneToFive contains 6"
        }
        
        method testListFirst {
            assert{empty.first} shouldRaise (BoundsError)
            assert(evens.first) shouldBe (2)
            assert(oneToFive.first) shouldBe (1)
        }
        
        method testListAt {
            assert {empty.at(1)} shouldRaise (BoundsError)
            assert (oneToFive.at(1)) shouldBe (1)
            assert (oneToFive[1]) shouldBe (1)
            assert (oneToFive.at(5)) shouldBe (5)
            assert (evens.at(4)) shouldBe (8)
            assert {evens.at(5)} shouldRaise (BoundsError)
        }

        method testListOrdinals {
            assert {empty.first} shouldRaise (BoundsError)
            assert (oneToFive.first) shouldBe (1)
            assert (oneToFive.second) shouldBe (2)
            assert (oneToFive.third) shouldBe (3)
            assert (evens.fourth) shouldBe (8)
            assert {evens.fifth} shouldRaise (BoundsError)
        }

        method testListAtPut {
            oneToFive.at(1) put (11)
            assert (oneToFive.at(1)) shouldBe (11)
            oneToFive.at(2) put (12)
            assert (oneToFive[2]) shouldBe (12)
            assert (oneToFive.at(3)) shouldBe (3)
            assert {evens.at 6 put 10} shouldRaise (BoundsError)
            assert {evens.at 0 put 0} shouldRaise (BoundsError)
        }
        
        method testListAtPutExtend {
            assert (empty.at 1 put 99) shouldBe (list.with 99)
            oneToFive.at(6) put 6
            assert (oneToFive.at 6) shouldBe 6
            oneToFive.at(7) put 7
            assert (oneToFive[7]) shouldBe 7
            assert (oneToFive) shouldBe (1..7)
        }
        
        method testListRemovePresent {
            assert (oneToFive.remove(3)) shouldBe (list.with(1, 2, 4, 5))
            assert (oneToFive) shouldBe (list.with(1, 2, 4, 5))
        }
        method testListRemoveMultiplePresent {
            assert (oneToFive.remove(1, 4, 5)) shouldBe (list.with(2, 3))
            assert (oneToFive) shouldBe (list.with(2, 3))
        }
        method testListRemoveAbsentExcpetion {
            assert {oneToFive.remove(1, 7, 5)} shouldRaise (NoSuchObject)
        }
        method testListRemoveAbsentActionBlock {
            assert (oneToFive.remove 9 ifAbsent {99}) shouldBe 99
        }
        method testListIndexOfPresent {
            assert (evens.indexOf 6) shouldBe 3
            assert (evens.indexOf 4 ifAbsent {"missing"}) shouldBe 2
        }
        method testListIndexOfAbsent {
            assert {evens.indexOf 3} shouldRaise (NoSuchObject)
            assert (evens.indexOf 5 ifAbsent {"missing"}) shouldBe "missing"
        }
        method testListAddLast {
            assert (empty.addLast(9)) shouldBe (list.with(9))
            assert (evens.addLast(10)) shouldBe (list.with(2, 4, 6, 8, 10))
        }
        method testAddAll {
            evens.addAll(oneToFive)
            assert (evens) shouldBe (list.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }
        method testListAdd {
            assert (empty.add(9)) shouldBe (list.with(9))
            assert (evens.add(10)) shouldBe (list.with(2, 4, 6, 8, 10))
        }
        method testListRemoveAtEmpty {
            assert {empty.removeAt(1)} shouldRaise (BoundsError)
        }
        method testListRemoveAt1 {
            assert (evens.removeAt(1)) shouldBe (2)
            assert (evens) shouldBe (list.with(4, 6, 8))
        }
        method testListRemoveAt2 {
            assert (evens.removeAt(2)) shouldBe (4)
            assert (evens) shouldBe (list.with(2, 6, 8))
        }
        method testListRemoveAt3 {
            assert (evens.removeAt(3)) shouldBe (6)
            assert (evens) shouldBe (list.with(2, 4, 8))
        }
        method testListRemoveAt4 {
            assert (evens.removeAt(4)) shouldBe (8)
            assert (evens) shouldBe (list.with(2, 4, 6))
        }
        method testListRemoveAt5 {
            assert {evens.removeAt(5)} shouldRaise (BoundsError)
        }
        method testListAddFirst {
            assert (evens.addFirst(0)) shouldBe (list.with(0, 2, 4, 6, 8))
            assert (evens.size) shouldBe (5)
            assert (evens.first) shouldBe (0)
            assert (evens.second) shouldBe (2)
        }
        method testListAddFirstMultiple {
            assert (evens.addFirst(-4, -2, 0)) shouldBe (list.with(-4, -2, 0, 2, 4, 6, 8))
            assert (evens.size) shouldBe 7
            assert (evens.first) shouldBe (-4)
            assert (evens.second) shouldBe (-2)
            assert (evens.third) shouldBe 0
            assert (evens.fourth) shouldBe 2
            assert (evens.fifth) shouldBe 4
            assert (evens.last) shouldBe 8
            assert (evens.at(3)) shouldBe 0
        }
        method testListRemoveFirst {
            def removed = oneToFive.removeFirst
            assert (removed) shouldBe (1)
            assert (oneToFive.size) shouldBe (4)
            assert (oneToFive) shouldBe (list.with(2, 3, 4, 5))
        }
        method testListChaining {        
            oneToFive.at(1)put(11).at(2)put(12).at(3)put(13)
            assert(oneToFive.at(1))shouldBe(11)
            assert(oneToFive.at(2))shouldBe(12)
            assert(oneToFive.at(3))shouldBe(13)
        }
        method testListPushAndExpand {
            evens.push(10)
            evens.push(12)
            evens.push(14)
            evens.push(16)
            evens.push(18)
            evens.push(20)
            assert (evens) shouldBe (list.with(2, 4, 6, 8, 10, 12, 14, 16, 18, 20))
        }
        
        method testListReversedOneToFive {
            def ofr = oneToFive.reversed
            assert (ofr) shouldBe (list.with(5, 4, 3, 2, 1))
            assert (oneToFive) shouldBe (list.with(1, 2, 3, 4, 5))
        }
        
        method testListReversedEvens {
            def er = evens.reversed
            assert (er) shouldBe (list.with(8, 6, 4, 2))
            assert (evens) shouldBe (list.with(2, 4, 6, 8))
            assert (er.reversed) shouldBe (evens)
        }
        
        method testListReversedEmpty {
            assert (empty.reversed) shouldBe (empty)
        }
        
        method testListReverseOneToFive {
            def ofr = oneToFive.reverse
            assert (identical(ofr, oneToFive)) description "reverse does not return self"
            assert (ofr) shouldBe (list.with(5, 4, 3, 2, 1))
            assert (oneToFive) shouldBe (list.with(5, 4, 3, 2, 1))
            oneToFive.reverse
            assert (oneToFive) shouldBe (list.with(1, 2, 3, 4, 5))
        }
        
        method testListReverseEvens {
            def er = evens.reverse
            assert (identical(er, evens)) description "reverse does not return self"
            assert (er) shouldBe (list.with(8, 6, 4, 2))
            assert (evens) shouldBe (list.with(8, 6, 4, 2))
            assert (er.reversed) shouldBe (list.with(2, 4, 6, 8))
        }
        
        method testListReverseEmpty {
            def er = empty.reverse
            assert (empty.reverse.size) shouldBe 0
        }

        method testListConcatWithEmpty {
            assert(empty ++ oneToFive)shouldBe(oneToFive)        
            assert(oneToFive ++ empty)shouldBe(oneToFive)
        }
        
        method testListConcatWithNonEmpty {
            assert(oneToFive ++ evens) shouldBe(list.with(1, 2, 3, 4, 5, 2, 4, 6, 8))
            assert(evens ++ oneToFive) shouldBe(list.with(2, 4, 6, 8, 1, 2, 3, 4, 5))
        }
        
        method testListIndicesAndKeys {
            def lst = oneToFive ++ evens
            def siz = oneToFive.size + evens.size
            assert (lst.indices) shouldBe (1..siz)
            assert (lst.indices) shouldBe (lst.keys.asSequence)
        }
        
        method testListFold {
            assert(oneToFive.fold{a, each -> a + each}startingWith(0))shouldBe(15)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)        
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }
        
        method testListDoSeparatedBy {
            var s := ""
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert (s) shouldBe ("2, 4, 6, 8")
        }
        
        method testListDoSeparatedByEmpty {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testListDoSeparatedBySingleton {
            var s := "nothing"
            list.with(1).do { each -> assert(each)shouldBe(1) } 
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testListKeysAndValuesDo {
            def accum = dictionary.empty
            var n := 1
            evens.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (dictionary.with(1::2, 2::4, 3::6, 4::8))
        }
         
        method testListAsStringNonEmpty {
            assert (evens.asString) shouldBe ("[2, 4, 6, 8]")
        }
             
        method testListAsStringEmpty {
            assert (empty.asString) shouldBe ("[]")
        }
        
        method testListMapEmpty {
            assert (empty.map{x -> x * x}.onto(list)) shouldBe (list.empty)
        }
        
        method testListMapEvens {
            assert(evens.map{x -> x + 1}.onto(list)) shouldBe (list.with(3, 5, 7, 9))
        }
        
        method testListMapEvensInto {
            assert(evens.map{x -> x + 10}.into(list.withAll(evens)))
                shouldBe (list.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        method testListFilterNone {
            deny(oneToFive.filter{x -> false}.iterator.hasNext)
        }
        
        method testListFilterEmpty {
            deny(empty.filter{x -> (x % 2) == 1}.iterator.hasNext)
        }

        method testListFilterOdd {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(list))
                shouldBe (list.with(1, 3, 5))
        }
        
        method testListMapAndFilter {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(list))
                shouldBe (list.with(11, 13, 15))
        }

        method testListCopy {
            def evensCopy = evens.copy
            evens.removeFirst
            evens.removeFirst
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe (list.with(2, 4, 6, 8))
            assert (evensCopy.second) shouldBe 4
        }
        
        method testListToSequence1to5 {
            assert (oneToFive.asSequence) shouldBe (sequence.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSequence) hasType (Sequence)
        }
        
        method testListToSequenceEmpty {
            assert (empty.asSequence) shouldBe (sequence.empty)
            assert (empty.asSequence) hasType (Sequence)
        }

        method testListToSet1to5 {
            assert (oneToFive.asSet) shouldBe (set.with(1, 2, 3, 4, 5))
            assert (oneToFive.asSet) hasType (Set)
        }
        
        method testListToSetEmpty {
            assert (empty.asSet) shouldBe (set.empty)
            assert (empty.asSet) hasType (Set)
        }
        method testListToSetDuplicates {
            def theSet = list.with(1,1,2,2,4).asSet
            assert (theSet) shouldBe (set.with(1, 2, 4))
            assert (theSet) hasType (Set)
        }
        method testListIteratorEmpty {
            deny (empty.iterator.hasNext)
                description "empty iterator has an element"
        }
        method testListIteratorNonEmpty {
            def accum = set.empty
            def iter = oneToFive.iterator
            while { iter.hasNext } do { accum.add(iter.next) }
            assert (accum) shouldBe (set.with(1, 2, 3, 4, 5))
        }
        method testListIteratorToSetDuplicates {
            def accum = set.empty
            def iter = list.with(1, 1, 2, 2, 4).iterator
            while { iter.hasNext } do { accum.add(iter.next) }
            assert (accum) shouldBe (set.with(1, 2, 4))
        }
        method testListSort {
            def input = list.with(7, 6, 4, 1)
            def output = list.with(1, 4, 6, 7)
            assert (input.sort) shouldBe (output)
            assert (input) shouldBe (output)
        }
        method testListSortBlock {
            def input = list.with(6, 7, 4, 1)
            def output = list.with(7, 6, 4, 1)
            assert (input.sortBy{a, b -> b - a}) shouldBe (output)
            assert (input) shouldBe (output)
        }        
        method testListSorted {
            def input = list.with(7, 6, 4, 1)
            def output = list.with(1, 4, 6, 7)
            assert (input.sorted) shouldBe (output)
            assert (input) shouldBe (list.with(7, 6, 4, 1))
        }
        method testListSortedBlock {
            def input = list.with(6, 7, 4, 1)
            def output = list.with(7, 6, 4, 1)
            assert (input.sortedBy{a, b -> b-a}) shouldBe (output)
            assert (input) shouldBe (list.with(6, 7, 4, 1))
        }
        method testListAsDictionary {
            assert(evens.asDictionary) shouldBe
                (dictionary.with(1::2, 2::4, 3::6, 4::8))
        }
    }
}

def setTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)

        def oneToFive = set.with(1, 2, 3, 4, 5)
        def evens = set.with(2, 4, 6, 8)
        def empty = set.empty


        method testSetSize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }
        
        method testSetSizeAfterRemove {
            oneToFive.remove(1, 3, 5)
            assert(oneToFive.size) shouldBe 2
        }

        method testSetEmptyDo {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
        }
        
        method testSetEqualityEmpty {
            assert(empty == set.empty)
            deny (empty != set.empty)
        }
        
        method testSetInequalityEmpty {
            deny(empty == set.with(1))
            assert(empty != set.with(1))
            deny(empty == 3)
            deny(empty == evens)
        }
        
        method testSetInequalityFive {
            deny(oneToFive == set.with(1, 2, 3, 4, 6))
            assert(oneToFive != set.with(1, 2, 3, 4, 6))
        }

        method testSetEqualityFive {
            def isEqual = (oneToFive == set.with(1, 2, 3, 4, 5))
            assert(isEqual)
            deny(oneToFive != set.with(1, 2, 3, 4, 5))
        }

        method testSetOneToFiveDo {
            def accum = set.empty
            var n := 1
            oneToFive.do { each -> 
                accum.add(each)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (oneToFive)
        }

        method testSetAdd {
            assert (empty.add(9)) shouldBe (set.with(9))
            assert (evens.add(10)) shouldBe (set.with(2, 4, 6, 8, 10))
        }

        method testSetRemove2 {
            assert (evens.remove(2)) shouldBe (set.with(4, 6, 8))
            assert (evens) shouldBe (set.with(4, 6, 8))
        }
        method testSetRemove4 {
            assert (evens.remove(4)) shouldBe (set.with(2, 6, 8))
            assert (evens) shouldBe (set.with(2, 6, 8))
        }
        method testSetRemove6 {
            assert (evens.remove(6)) shouldBe (set.with(2, 4, 8))
            assert (evens) shouldBe (set.with(2, 4, 8))
        }
        method testSetRemove8 {
            assert (evens.remove(8)) shouldBe (set.with(2, 4, 6))
            assert (evens) shouldBe (set.with(2, 4, 6))
        }
        method testSetRemoveMultiple {
            assert (evens.remove(4, 6, 8)) shouldBe (set.with(2))
            assert (evens) shouldBe (set.with(2))
        }
        method testSetRemove5 {
            assert {evens.remove(5)} shouldRaise (NoSuchObject)
        }

        method testSetChaining {        
            oneToFive.add(11).add(12).add(13)
            assert (oneToFive) shouldBe (set.with(1, 2, 3, 4, 5, 11, 12, 13))
        }
        method testSetPushAndExpand {
            evens.add(10)
            evens.add(12)
            evens.add(14)
            evens.add(16, 18, 20)
            assert (evens) shouldBe (set.with(2, 4, 6, 8, 10, 12, 14, 16, 18, 20))
        }    
        method testEmptyIterator {
            deny (empty.iterator.hasNext) description "the empty iterator has an element"
        }
        method testEvensIterator {
            def ei = evens.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copySet = set.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copySet) shouldBe (evens)
        }
        method testSetFold {
            assert(oneToFive.fold{a, each -> a + each}startingWith(5))shouldBe(20)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)        
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }
        
        method testSetDoSeparatedBy {
            var s := ""
            evens.remove(2).remove(4)
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert ((s == "6, 8") || (s == "8, 6")) 
                description "{s} should be \"8, 6\" or \"6, 8\""
        }
        
        method testSetDoSeparatedByEmpty {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testSetDoSeparatedBySingleton {
            var s := "nothing"
            set.with(1).do { each -> assert(each)shouldBe(1) } 
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
         
        method testSetAsStringNonEmpty {
            evens.remove(6).remove(8)
            assert ((evens.asString == "set\{2, 4\}") || (evens.asString == "set\{4, 2\}"))
                description "set\{2, 4\}.asString is {evens.asString}"
        }
             
        method testSetAsStringEmpty {
            assert (empty.asString) shouldBe ("set\{\}")
        }
        
        method testSetMapEmpty {
            assert (empty.map{x -> x * x}.onto(set)) shouldBe (set.empty)
        }
        
        method testSetMapEvens {
            assert(evens.map{x -> x + 1}.onto(set)) shouldBe (set.with(3, 5, 7, 9))
        }
        
        method testSetMapEvensInto {
            assert(evens.map{x -> x + 10}.into(set.withAll(evens)))
                shouldBe (set.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        method testSetFilterNone {
            assert(oneToFive.filter{x -> false}.isEmpty)
                description "filtered(false) set isn't empty"
        }
        
        method testSetFilterEmpty {
            assert(evens.filter{x -> (x % 2) == 1}.isEmpty)
                description "filtered(odd) set isn't empty"
        }

        method testSetFilterOdd {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (set.with(1, 3, 5))
        }
        
        method testSetMapAndFilter {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (set.with(11, 13, 15))
        }
        
        method testSetCopy {
            def evensCopy = evens.copy
            evens.remove(2, 4)
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe (set.with(2, 4, 6, 8))
        }
        method testSetUnion {
            assert (oneToFive ++ evens) shouldBe (set.with(1, 2, 3, 4, 5, 6, 8))
        }
        method testSetDifference {
            assert (oneToFive -- evens) shouldBe (set.with(1, 3, 5))
        }
        method testSetIntersection {
            assert (oneToFive ** evens) shouldBe (set.with(2, 4))
        }
    }
}

def dictionaryTest = object {
    factory method forMethod(m) {
        inherits gU.testCaseNamed(m)
        def oneToFive = dictionary.with("one"::1, "two"::2, "three"::3, 
            "four"::4, "five"::5)
        def evens = dictionary.with("two"::2, "four"::4, "six"::6, "eight"::8)
        def empty = dictionary.empty
        
        
        method testDictionaryTypeCollection {
            assert (oneToFive) hasType (Collection<Binding<String,Number>>)
        }
        method testDictionaryTypeDictionary {
            assert (oneToFive) hasType (Dictionary<String,Number>)
        }
        method testDictionaryTypeNotTypeWithWombat {
            deny (oneToFive) hasType (Dictionary<String,Number> & type { wombat })
        }

        method testDictionarySize {
            assert(oneToFive.size) shouldBe 5
            assert(empty.size) shouldBe 0
            assert(evens.size) shouldBe 4
        }

        method testDictionarySizeAfterRemove {
            oneToFive.removeKey "one"
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            oneToFive.removeKey "two"
            oneToFive.removeKey "three"
            assert(oneToFive.size) shouldBe 2
        }
        
        method testDictionaryContentsAfterMultipleRemove {
            oneToFive.removeKey("one", "two", "three")
            assert(oneToFive.size) shouldBe 2
            deny(oneToFive.containsKey "one") description "\"one\" still present"
            deny(oneToFive.containsKey "two") description "\"two\" still present"
            deny(oneToFive.containsKey "three") description "\"three\" still present"
            assert(oneToFive.containsKey "four")
            assert(oneToFive.containsKey "five")
        }
        
        method testAsString {
            def dict2 = dictionary.with("one"::1, "two"::2)
            def dStr = dict2.asString
            assert((dStr == "dict⟬one::1, two::2⟭").orElse{dStr == "dict⟬two::2, one::1⟭"})
                description "\"{dStr}\" should be \"dict⟬one::1, two::2⟭\""
        }
        
        method testAsStringEmpty {
            assert(empty.asString) shouldBe "dict⟬⟭"
        }

        method testDictionaryEmptyDo {
            empty.do {each -> failBecause "emptySet.do did with {each}"}
            assert (true)   // so that there is always an assert
        }

        method testDictionaryEqualityEmpty {
            assert(empty == dictionary.empty)
            deny(empty != dictionary.empty)
        }
        method testDictionaryInequalityEmpty {
            deny(empty == dictionary.with("one"::1)) 
                description "empty dictionary equals dictionary with \"one\"::1"
            assert(empty != dictionary.with("two"::2))
                description "empty dictionary equals dictionary with \"two\"::2"
            deny(empty == 3)
            deny(empty == evens)
        }
        method testDictionaryInequalityFive {
            evens.at "ten" put 10
            assert(evens.size == oneToFive.size) description "evens.size should be 5"
            deny(oneToFive == evens)
            assert(oneToFive != evens)
        }
        method testDictionaryEqualityFive {
            assert(oneToFive == dictionary.with("one"::1, "two"::2, "three"::3,
                "four"::4, "five"::5))
        }
        method testDictionaryKeysAndValuesDo {
            def accum = dictionary.empty
            var n := 1
            oneToFive.keysAndValuesDo { k, v ->
                accum.at(k)put(v)
                assert (accum.size) shouldBe (n)
                n := n + 1
            }
            assert(accum) shouldBe (oneToFive)
        }
        method testDictionaryEmptyBindingsIterator {
            deny (empty.bindings.iterator.hasNext) 
                description "the empty bindings iterator has elements"
        }
        method testDictionaryEvensBindingsIterator {
            def ei = evens.bindings.iterator
            assert (evens.size == 4) description "evens doesn't contain 4 elements!"
            assert (ei.hasNext) description "the evens iterator has no elements"
            def copyDict = dictionary.with(ei.next, ei.next, ei.next, ei.next)
            deny (ei.hasNext) description "the evens iterator has more than 4 elements"
            assert (copyDict) shouldBe (evens)
        }
        method testDictionaryAdd {
            assert (empty.at "nine" put(9)) 
                shouldBe (dictionary.with("nine"::9))
            assert (evens.at "ten" put(10).values.onto(set)) 
                shouldBe (set.with(2, 4, 6, 8, 10))
        }
        method testDictionaryRemoveKeyTwo {
            assert (evens.removeKey "two".values.onto(set)) shouldBe (set.with(4, 6, 8))
            assert (evens.values.onto(set)) shouldBe (set.with(4, 6, 8))
        }
        method testDictionaryRemoveValue4 {
            assert (evens.size == 4) description "evens doesn't contain 4 elements"
            evens.removeValue(4)
            assert (evens.size == 3) 
                description "after removing 4, 3 elements should remain"
            assert (evens.containsKey "two") description "Can't find key \"two\""
            assert (evens.containsKey "six") description "Can't find key \"six\""
            assert (evens.containsKey "eight") description "Can't find key \"eight\""
            deny (evens.containsKey "four") description "Found key \"four\""
            assert (evens.removeValue(4).values.onto(set)) shouldBe (set.with(2, 6, 8))
            assert (evens.values.onto(set)) shouldBe (set.with(2, 6, 8))
            assert (evens.keys.onto(set)) shouldBe (set.with("two", "six", "eight"))
        }
        method testDictionaryRemoveMultiple {
            evens.removeValue(4, 6, 8)
            assert (evens) shouldBe (dictionary.at"two"put(2))
        }
        method testDictionaryRemove5 {
            assert {evens.removeKey(5)} shouldRaise (NoSuchObject)
        }
        method testDictionaryRemoveKeyFive {
            assert {evens.removeKey("Five")} shouldRaise (NoSuchObject)
        }
        method testDictionaryChaining {        
            oneToFive.at "eleven" put(11).at "twelve" put(12).at "thirteen" put(13)
            assert (oneToFive.values.onto(set)) shouldBe (set.with(1, 2, 3, 4, 5, 11, 12, 13))
        }
        method testDictionaryPushAndExpand {
            evens.removeKey "two"
            evens.removeKey "four"
            evens.removeKey "six"
            evens.at "ten" put(10)
            evens.at "twelve" put(12)
            evens.at "fourteen" put(14)
            evens.at "sixteen" put(16)
            evens.at "eighteen" put(18)
            evens.at "twenty" put(20)
            assert (evens.values.onto(set)) 
                shouldBe (set.with(8, 10, 12, 14, 16, 18, 20))
        }

        method testDictionaryFold {
            assert(oneToFive.fold{a, each -> a + each}startingWith(5))shouldBe(20)
            assert(evens.fold{a, each -> a + each}startingWith(0))shouldBe(20)        
            assert(empty.fold{a, each -> a + each}startingWith(17))shouldBe(17)
        }
        
        method testDictionaryDoSeparatedBy {
            var s := ""
            evens.removeValue(2, 4)
            evens.do { each -> s := s ++ each.asString } separatedBy { s := s ++ ", " }
            assert ((s == "6, 8") || (s == "8, 6")) 
                description "{s} should be \"8, 6\" or \"6, 8\""
        }

        method testDictionaryDoSeparatedByEmpty {
            var s := "nothing"
            empty.do { failBecause "do did when list is empty" }
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }
        
        method testDictionaryDoSeparatedBySingleton {
            var s := "nothing"
            set.with(1).do { each -> assert(each)shouldBe(1) } 
                separatedBy { s := "kilroy" }
            assert (s) shouldBe ("nothing")
        }

        method testDictionaryAsStringNonEmpty {
            evens.removeValue(6, 8)
            assert ((evens.asString == "dict⟬two::2, four::4⟭") ||
                        (evens.asString == "dict⟬four::4, two::2⟭"))
                        description "evens.asString = {evens.asString}"
        }

        method testDictionaryAsStringEmpty {
            assert (empty.asString) shouldBe ("dict⟬⟭")
        }

        method testDictionaryMapEmpty {
            assert (empty.map{x -> x * x}.onto(set)) shouldBe (set.empty)
        }
        
        method testDictionaryMapEvens {
            assert(evens.map{x -> x + 1}.onto(set)) shouldBe (set.with(3, 5, 7, 9))
        }

        method testDictionaryMapEvensInto {
            assert(evens.map{x -> x + 10}.into(set.withAll(evens)))
                shouldBe (set.with(2, 4, 6, 8, 12, 14, 16, 18))
        }

        method testDictionaryFilterNone {
            assert(oneToFive.filter{x -> false}.isEmpty)
        }
        
        method testDictionaryFilterEmpty {
            assert(empty.filter{x -> (x % 2) == 1}.isEmpty)
        }

        method testDictionaryFilterOdd {
            assert(oneToFive.filter{x -> (x % 2) == 1}.onto(set))
                shouldBe (set.with(1, 3, 5))
        }
        
        method testDictionaryMapAndFilter {
            assert(oneToFive.map{x -> x + 10}.filter{x -> (x % 2) == 1}.asSet)
                shouldBe (set.with(11, 13, 15))
        }
        method testDictionaryBindings {
            assert(oneToFive.bindings.onto(set)) shouldBe (
                set.with("one"::1, "two"::2, "three"::3, "four"::4, "five"::5))
        }
        method testDictionaryKeys {
            assert(oneToFive.keys.onto(set)) shouldBe (
                set.with("one", "two", "three", "four", "five") )
        }
        method testDictionaryValues {
            assert(oneToFive.values.onto(set)) shouldBe (
                set.with(1, 2, 3, 4, 5) )
        }
        
        method testDictionaryCopy {
            def evensCopy = evens.copy
            evens.removeKey("two")
            evens.removeValue(4)
            assert (evens.size) shouldBe 2
            assert (evensCopy) shouldBe 
                (dictionary.with("two"::2, "four"::4, "six"::6, "eight"::8))
        }
        
        method testDictionaryAsDictionary {
            assert(evens.asDictionary) shouldBe (evens)
        }
        
        method testDictionaryValuesEmpty {
            def vs = empty.values
            assert(vs.isEmpty)
            assert(vs) shouldBe (sequence.empty)
        }
        method testDictionaryKeysEmpty {
            assert(empty.keys) shouldBe (sequence.empty)
        }
        method testDictionaryValuesSingle {
            assert(dictionary.with("one"::1).values) shouldBe
                (sequence.with 1)
        }
        method testDictionaryKeysSingle {
            assert(dictionary.with("one"::1).keys) shouldBe
                (sequence.with "one")
        }
        method testDictionaryBindingsEvens {
            assert(evens.bindings.asSet) shouldBe
                (set.with("two"::2, "four"::4, "six"::6, "eight"::8))
        }
        method testDictionarySortedOnValues {
            assert(evens.bindings.sortedBy{b1, b2 -> b1.value.compare(b2.value)})
                shouldBe (sequence.with("two"::2, "four"::4, "six"::6, "eight"::8))
        }
        method testDictionarySortedOnKeys {
            assert(evens.bindings.sortedBy{b1, b2 -> b1.key.compare(b2.key)})
                shouldBe (sequence.with("eight"::8, "four"::4, "six"::6, "two"::2))
        }
    }
}

print "binding"
def bindingTests = gU.testSuite.fromTestMethodsIn(bindingTest)
bindingTests.runAndPrintResults

print "sequence"
def sequenceTests = gU.testSuite.fromTestMethodsIn(sequenceTest)
sequenceTests.runAndPrintResults

print "list"
def listTests = gU.testSuite.fromTestMethodsIn(listTest)
listTests.runAndPrintResults

print "set"
def setTests = gU.testSuite.fromTestMethodsIn(setTest)
setTests.runAndPrintResults

print "range"
def rangeTests = gU.testSuite.fromTestMethodsIn(rangeTest)
rangeTests.runAndPrintResults

print "dictionary"
def dictTests = gU.testSuite.fromTestMethodsIn(dictionaryTest)
dictTests.runAndPrintResults

//def allTests = gU.testSuite.with(bindingTests, sequenceTests, listTests, rangeTests, setTests, dictTests)
//allTests.runAndPrintResults
