(* We're using Coq to prove a subset of the FizzBuzz logic, and doing the rest in Haskell. *)
Extraction Language Haskell.

(* In the extraction, we want this to just vanish. *)
Extraction Inline proj1_sig.

(* Types we're importing from Haskell. *)
Extract Inductive sumbool => "Prelude.Bool" [ "Prelude.True" "Prelude.False" ].

Axiom Integer : Set.
Extract Constant Integer => "Prelude.Integer".
Extraction Inline Integer.

Axiom String : Set.
Extract Constant String => "Prelude.String".
Extraction Inline String.

(* We have decidable equality on Integers. *)
Axiom Integer_eq : forall (n m : Integer), { n = m }+{ n <> m }.
Extract Constant Integer_eq => "(Prelude.==)".
Extraction Inline Integer_eq.

(* A few constants. *)
Axiom zero : Integer.
Extract Constant zero => "0".
Extraction Inline zero.
Notation "0" := zero.

Axiom three : Integer.
Extract Constant three => "3".
Extraction Inline three.
Notation "3" := three.

Axiom five : Integer.
Extract Constant five => "5".
Extraction Inline five.
Notation "5" := five.

Axiom empty : String.
Extract Constant empty => """""".
Extraction Inline empty.

Axiom fizz : String.
Extract Constant fizz => """Fizz""".
Extraction Inline fizz.

Axiom buzz : String.
Extract Constant buzz => """Buzz""".
Extraction Inline buzz.

Axiom nl : String.
Extract Constant nl => """\n""".
Extraction Inline nl.

(* Functions that we're importing from Haskell. *)
Axiom append : String -> String -> String.
Extract Constant append => "(Prelude.++)".
Extraction Inline append.

Axiom mod : Integer -> Integer -> Integer.
Extract Constant mod => "Prelude.mod".
Extraction Inline mod.

Axiom show : Integer -> String.
Extract Constant show => "Prelude.show".
Extraction Inline show.

(* What does it mean for a number to evenly divide another number? *)
Inductive Divides (den num : Integer) : Prop :=
| ModZero : mod num den = zero -> Divides den num
.

Notation "( D | N )" := (Divides D N).

(* Divisibility is decidable. *)
Lemma Divides_dec (den num : Integer) : { ( den | num ) }+{ ~ ( den | num ) }.
  remember (mod num den) as m.
  remember (Integer_eq m 0) as mzero.
  destruct mzero.

    left.
    apply ModZero.
    rewrite e in Heqm.
    rewrite Heqm.
    reflexivity.

    right.
    intro contra.
    destruct contra.
    rewrite H in Heqm.
    contradiction.
Qed.
Extraction Inline Divides_dec.

(* The conditions under which we can produce each word. *)
Inductive Fizz (n : Integer) : String -> Prop :=
| EmitFizz : (3 | n) -> Fizz n fizz
| NoEmitFizz : ~(3 | n) -> Fizz n empty
.

Inductive Buzz (n : Integer) : String -> Prop :=
| EmitBuzz : (5 | n) -> Buzz n buzz
| NoEmitBuzz : ~(5 | n) -> Buzz n empty
.

Inductive Show (n : Integer) : String -> Prop :=
| EmitShow : ~(3 | n) -> ~(5 | n) -> Show n (show n)
| NoEmitShow : (3 | n) \/ (5 | n) -> Show n empty
.

Hint Constructors Fizz.
Hint Constructors Buzz.
Hint Constructors Show.

(* We can decide strings which satisfy the above conditions. *)
Lemma Fizz_dec (n : Integer) : { s : String | Fizz n s }.
  remember (Divides_dec 3 n) as d3.
  destruct d3.

    exists fizz.
    auto.

    exists empty.
    auto.
Qed.
Extraction Inline Fizz_dec.

Lemma Buzz_dec (n : Integer) : { s : String | Buzz n s }.
  remember (Divides_dec 5 n) as d5.
  destruct d5.

    exists buzz.
    auto.

    exists empty.
    auto.
Qed.
Extraction Inline Buzz_dec.

Lemma Show_dec (n : Integer) : { s : String | Show n s }.
  remember (Divides_dec 3 n) as d3.
  remember (Divides_dec 5 n) as d5.
  destruct d3; destruct d5.

    exists empty.
    auto.

    exists empty.
    auto.

    exists empty.
    auto.

    exists (show n).
    auto.
Qed.
Extraction Inline Show_dec.

(* So, the operation to fizzbuzz a single number. *)
Definition fizzbuzz (n : Integer) : String :=
  let fizz := proj1_sig (Fizz_dec n) in
  let buzz := proj1_sig (Buzz_dec n) in
  let bare := proj1_sig (Show_dec n) in
  append fizz (append buzz (append bare nl)).

(* Finally, the code we want to extract. *)
Extraction fizzbuzz.
