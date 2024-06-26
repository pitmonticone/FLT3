/-
Copyright (c) 2024 Riccardo Brasca. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Riccardo Brasca, Sanyam Gupta, Omar Haddad, David Lowry-Duda,
  Lorenzo Luccioli, Pietro Monticone, Alexis Saurin, Florent Schaffhauser
-/
import FLT3.Mathlib.NumberTheory.Cyclotomic.PID
import FLT3.Mathlib.NumberTheory.FLT.Basic
import FLT3.Mathlib.NumberTheory.FLT.Three
import FLT3.Cyclo
-- import Mathlib.NumberTheory.Cyclotomic.PID
-- import Mathlib.NumberTheory.FLT.Basic
-- import Mathlib.NumberTheory.FLT.Three

/-!
# Fermat's Last Theorem for Exponent `n = 3`
The goal of this file is to prove Fermat's Last Theorem for exponent `3`, namely that
for all `a`, `b`, `c` in `ℕ` such that `a ≠ 0` and `b ≠ 0` and `c ≠ 0`,
then `a ^ 3 + b ^ 3 ≠ c ^ 3`.
-/

open NumberField nonZeroDivisors IsCyclotomicExtension.Rat.Three

section case2

open scoped Classical

section misc

/-- Let `a`, `b`, `c` be in `ℕ`. If `3 ∣ a` and `3 ∣ c` and `a ^ 3 + b ^ 3 = c ^ 3`,
then 3 divides the `gcd` of the set `{a, b, c}`. -/
lemma three_dvd_gcd_of_dvd_a_of_dvd_c {a b c : ℕ} (ha : 3 ∣ a) (hc : 3 ∣ c)
    (hF : a ^ 3 + b ^ 3 = c ^ 3) : 3 ∣ ({a, b, c} : Finset ℕ).gcd id := by
  have hb : 3 ∣ b := by
    have : 3 ∣ (b : ℤ) ^ 3 := by
      replace hF : (a : ℤ) ^ 3 + (b : ℤ) ^ 3 = (c : ℤ) ^ 3 := by exact_mod_cast hF
      rw [add_comm, ← eq_sub_iff_add_eq] at hF
      rw [hF]
      exact dvd_sub (dvd_pow (by exact_mod_cast hc) (by decide))
        (dvd_pow (by exact_mod_cast ha) (by decide))
    exact Int.coe_nat_dvd.1 <| Int.prime_three.dvd_of_dvd_pow this
  refine Finset.dvd_gcd (fun x hx ↦ ?_)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with (hx | hx | hx)
  · exact hx ▸ ha
  · exact hx ▸ hb
  · exact hx ▸ hc

/-- Let `a`, `b`, `c` be in `ℕ`. . If `3 ∣ a` and `3 ∣ b` and `a ^ 3 + b ^ 3 = c ^ 3`,
then 3 divides the `gcd` of the set `{a, b, c}`. -/
lemma three_dvd_gcd_of_dvd_a_of_dvd_b {a b c : ℕ} (ha : 3 ∣ a) (hb : 3 ∣ b)
    (hF : a ^ 3 + b ^ 3 = c ^ 3) : 3 ∣ ({a, b, c} : Finset ℕ).gcd id := by
  have hc : 3 ∣ c := by
    have : 3 ∣ (c : ℤ) ^ 3 := by
      replace hF : (a : ℤ) ^ 3 + (b : ℤ) ^ 3 = (c : ℤ) ^ 3 := by exact_mod_cast hF
      rw [← hF]
      exact dvd_add (dvd_pow (by exact_mod_cast ha) (by decide))
        (dvd_pow (by exact_mod_cast hb) (by decide))
    exact Int.coe_nat_dvd.1 <| Int.prime_three.dvd_of_dvd_pow this
  refine Finset.dvd_gcd (fun x hx ↦ ?_)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with (hx | hx | hx)
  · exact hx ▸ ha
  · exact hx ▸ hb
  · exact hx ▸ hc

/-- Let `a`, `b`, `c` be in `ℕ`. . If `3 ∣ b` and `3 ∣ c` and `a ^ 3 + b ^ 3 = c ^ 3`,
then 3 divides the `gcd` of the set `{a, b, c}`. -/
lemma three_dvd_gcd_of_dvd_b_of_dvd_c {a b c : ℕ} (hb : 3 ∣ b) (hc : 3 ∣ c)
    (hF : a ^ 3 + b ^ 3 = c ^ 3) : 3 ∣ ({a, b, c} : Finset ℕ).gcd id := by
  have ha : 3 ∣ a := by
    have : 3 ∣ (a : ℤ) ^ 3 := by
      replace hF : (a : ℤ) ^ 3 + (b : ℤ) ^ 3 = (c : ℤ) ^ 3 := by exact_mod_cast hF
      rw [← eq_sub_iff_add_eq] at hF
      rw [hF]
      exact dvd_sub (dvd_pow (by exact_mod_cast hc) (by decide))
            (dvd_pow (by exact_mod_cast hb) (by decide))
    exact Int.coe_nat_dvd.1 <| Int.prime_three.dvd_of_dvd_pow this
  refine Finset.dvd_gcd (fun x hx ↦ ?_)
  simp only [Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with (hx | hx | hx)
  · exact hx ▸ ha
  · exact hx ▸ hb
  · exact hx ▸ hc

open Finset Int Nat in

/-- To prove Fermat's Last Theorem for exponent `n = 3`,
it suffices to show that that for all `a`, `b`, `c` in `ℤ` such that
`c ≠ 0`, `¬ 3 ∣ a`, `¬ 3 ∣ b`, `3 ∣ c`, `a` and `b` are coprime,
we have `a ^ 3 + b ^ 3 ≠ c ^ 3`. -/
theorem fermatLastTheoremThree_of_three_dvd_only_c
    (H : ∀ a b c : ℤ, c ≠ 0 → ¬ 3 ∣ a → ¬ 3 ∣ b  → 3 ∣ c → IsCoprime a b → a ^ 3 + b ^ 3 ≠ c ^ 3) :
    FermatLastTheoremFor 3 := by
  refine fermatLastTheoremWith_of_fermatLastTheoremWith_coprime (fun a b c ha hb hc Hgcd hF ↦?_)
  by_cases h1 : 3 ∣ a * b * c
  swap; exact fermatLastTheoremThree_case_1 h1 hF
  rw [(Nat.prime_three).dvd_mul, (Nat.prime_three).dvd_mul] at h1
  have h3 : ¬(3 ∣ 1) := by decide
  rcases h1 with ((⟨k, hk⟩ | ⟨k, hk⟩) | ⟨k, hk⟩)
  · refine H (-(c : ℤ)) b (-(a : ℤ)) (by simp [ha]) (fun hdvd ↦ h3 ?_) (fun hdvd ↦ h3 ?_) ?_ ?_ ?_
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_a_of_dvd_c ⟨k, hk⟩ (coe_nat_dvd.1 (dvd_neg.1 hdvd)) hF
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_a_of_dvd_b ⟨k, hk⟩ (by exact_mod_cast hdvd) hF
    · exact ⟨-k, by simp [hk]⟩
    · refine (isCoprime_iff_coprime.2 (coprime_of_dvd' (fun p hp hpc hpb ↦ ?_))).neg_left
      rw [← Hgcd]; refine dvd_gcd (fun x hx ↦ ?_)
      simp only [mem_insert, mem_singleton] at hx
      rcases hx with (hx | hx | hx)
      · refine hx ▸ (hp.dvd_of_dvd_pow <| (Nat.dvd_add_iff_right (m := b ^ 3) (n := a ^ 3)
          (dvd_pow hpb (by decide))).2 ?_)
        rw [add_comm, hF]
        exact dvd_pow hpc (by decide)
      · exact hx ▸ hpb
      · exact hx ▸ hpc
    · rw [Odd.neg_pow (by decide), Odd.neg_pow (by decide), add_comm, ← sub_eq_add_neg,
        sub_eq_iff_eq_add, add_comm, ← sub_eq_add_neg, eq_sub_iff_add_eq, add_comm]
      exact_mod_cast hF
  · refine H a (-(c : ℤ)) ((-(b : ℤ))) (by simp [hb]) (fun hdvd ↦ h3 ?_) (fun hdvd ↦ h3 ?_) ?_ ?_ ?_
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_a_of_dvd_b (by exact_mod_cast hdvd) ⟨k, hk⟩ hF
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_b_of_dvd_c ⟨k, hk⟩ (coe_nat_dvd.1 (dvd_neg.1 hdvd)) hF
    · exact ⟨-k, by simp [hk]⟩
    · refine (Nat.isCoprime_iff_coprime.2 (coprime_of_dvd' (fun p hp hpa hpc ↦ ?_))).neg_right
      rw [← Hgcd]; refine dvd_gcd (fun x hx ↦ ?_)
      simp only [mem_insert, mem_singleton] at hx
      rcases hx with (hx | hx | hx)
      · exact hx ▸ hpa
      · exact hx ▸ (hp.dvd_of_dvd_pow <| (Nat.dvd_add_iff_right (m := a ^ 3) (n := b ^ 3)
          (dvd_pow hpa (by decide))).2 (hF ▸ dvd_pow hpc (by decide)))
      · exact hx ▸ hpc
    · rw [Odd.neg_pow (by decide), Odd.neg_pow (by decide), ← sub_eq_add_neg, sub_eq_iff_eq_add,
        add_comm, ← sub_eq_add_neg, eq_sub_iff_add_eq]
      exact_mod_cast hF
  · refine H a b c (by simp [hc]) (fun hdvd ↦ h3 ?_) (fun hdvd ↦ h3 ?_) ?_ ?_ ?_
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_a_of_dvd_c (by exact_mod_cast hdvd) ⟨k, hk⟩ hF
    · exact Hgcd.symm ▸ three_dvd_gcd_of_dvd_b_of_dvd_c (by exact_mod_cast hdvd) ⟨k, hk⟩ hF
    · exact ⟨k, by simp [hk]⟩
    · refine isCoprime_iff_coprime.2 (coprime_of_dvd' (fun p hp hpa hpb ↦ ?_))
      rw [← Hgcd]; refine dvd_gcd (fun x hx ↦ ?_)
      simp only [mem_insert, mem_singleton] at hx
      rcases hx with (hx | hx | hx)
      · exact hx ▸ hpa
      · exact hx ▸ hpb
      · refine hx ▸ hp.dvd_of_dvd_pow (n := 3) ?_
        exact hF.symm ▸ dvd_add (dvd_pow hpa (by decide)) (dvd_pow hpb (by decide))
    · exact_mod_cast hF

end misc

section eisenstein

attribute [instance] IsCyclotomicExtension.Rat.three_pid

local notation3 "K" => CyclotomicField 3 ℚ

instance : NumberField K := IsCyclotomicExtension.numberField {3} ℚ _

attribute [-instance] ValuationRing.instIsBezoutToRing -- This seems to be a very slow instance
-- #check ValuationRing.instIsBezoutToRing
-- #check ValuationRing.instValuationRing

-- This takes Lean some time, so let's do it here once
local instance : IsBezout (𝓞 K) := by infer_instance

noncomputable
instance : NormalizedGCDMonoid (𝓞 K) :=
  have : Nonempty (NormalizedGCDMonoid (𝓞 K)) := inferInstance
  this.some

/-- Let `K` be `CyclotomicField 3 ℚ`. Let `η : 𝓞 K` be the root of unity given by
`IsCyclotomicExtension.zeta`. Let `λ = η - 1`. -/
def hζ := IsCyclotomicExtension.zeta_spec 3 ℚ K
local notation3 "η" => hζ.toInteger
local notation3 "λ" => η - 1

/-- `FermatLastTheoremForThreeGen` is the statement that `a ^ 3 + b ^ 3 = u * c ^ 3` has no
nontrivial solutions in `𝓞 K` for all `u : (𝓞 K)ˣ` such that `¬ λ ∣ a`, `¬ λ ∣ b` and `λ ∣ c`.
The reason to consider `FermatLastTheoremForThreeGen` is to make a descent argument working. -/
def FermatLastTheoremForThreeGen : Prop :=
  ∀ a b c : 𝓞 K, ∀ u : (𝓞 K)ˣ, c ≠ 0 → ¬ λ ∣ a → ¬ λ ∣ b  → λ ∣ c → IsCoprime a b →
    a ^ 3 + b ^ 3 ≠ u * c ^ 3

/-- To prove `FermatLastTheoremFor 3`, it suffices to prove `FermatLastTheoremForThreeGen`. -/
lemma FermatLastTheoremForThree_of_FermatLastTheoremThreeGen :
    FermatLastTheoremForThreeGen → FermatLastTheoremFor 3 := by
  intro H
  refine fermatLastTheoremThree_of_three_dvd_only_c (fun a b c hc ha hb ⟨x, hx⟩ hcoprime h ↦ ?_)
  refine H a b c 1 (by simp [hc]) (fun hdvd ↦ ha ?_) (fun hdvd ↦ hb ?_) ?_ ?_ ?_
  · rwa [← Ideal.norm_dvd_iff (norm_lambda_prime hζ), norm_lambda hζ] at hdvd
  · rwa [← Ideal.norm_dvd_iff (norm_lambda_prime hζ), norm_lambda hζ] at hdvd
  · exact dvd_trans (lambda_dvd_three hζ) ⟨x, by simp [hx]⟩
  · rw [show a = algebraMap _ (𝓞 K) a by simp, show b = algebraMap _ (𝓞 K) b by simp]
    exact hcoprime.map _
  · simp only [Units.val_one, one_mul]
    exact_mod_cast h

section Solution'

/-- `Solution'` is a tuple given by a solution to `a ^ 3 + b ^ 3 = u * c ^ 3`,
where `a`, `b`, `c` and `u` are as above. See `Solution` for the actual structure on which we will
do the descent. -/
structure Solution' where
  (a : 𝓞 K)
  (b : 𝓞 K)
  (c : 𝓞 K)
  (u : (𝓞 K)ˣ)
  (ha : ¬ λ ∣ a)
  (hb : ¬ λ ∣ b)
  (hc : c ≠ 0)
  (coprime : IsCoprime a b)
  (hcdvd : λ ∣ c)
  (H : a ^ 3 + b ^ 3 = u * c ^ 3)

/-- `Solution` is the same as `Solution'` with the additional assumption that `λ ^ 2 ∣ a + b`. -/
structure Solution extends Solution' where
  (hab : λ ^ 2 ∣ a + b)

variable (S : Solution) (S' : Solution')

/-- For any `S' : Solution'`, the multiplicity of `λ` in `S'.c` is finite. -/
lemma Solution'.multiplicity_lambda_c_finite :
    multiplicity.Finite (hζ.toInteger - 1) S'.c :=
  multiplicity.finite_of_not_isUnit (lambda_not_unit hζ) S'.hc

/-- Given `S' : Solution'`, `S'.multiplicity` is the multiplicity of `λ` in `S'.c`, as a natural
number. -/
noncomputable
def Solution'.multiplicity :=
  (_root_.multiplicity (hζ.toInteger - 1) S'.c).get (multiplicity_lambda_c_finite S')

/-- Given `S : Solution`, `S.multiplicity` is the multiplicity of `λ` in `S.c`, as a natural
number. -/
noncomputable
def Solution.multiplicity := S.toSolution'.multiplicity

/-- We say that `S : Solution` is minimal if for all `S₁ : Solution`, the multiplicity of `λ` in
`S.c` is less or equal than the multiplicity in `S₁.c`. -/
def Solution.isMinimal : Prop := ∀ (S₁ : Solution), S.multiplicity ≤ S₁.multiplicity

/-- If there is a solution then there is a minimal one. -/
lemma Solution.exists_minimal : ∃ (S₁ : Solution), S₁.isMinimal := by
  let T : Set ℕ := { n | ∃ (S' : Solution), S'.multiplicity = n }
  rcases Nat.find_spec (⟨S.multiplicity, ⟨S, rfl⟩⟩ : T.Nonempty) with ⟨S₁, hS₁⟩
  exact ⟨S₁, fun S'' ↦ hS₁ ▸ Nat.find_min' _ ⟨S'', rfl⟩⟩

end Solution'

section FermatLastTheoremForThreeGen

section Solution'

variable (S : Solution')

/-- Given `S : Solution'`, then `λ ^ 4 ∣ S.a ^ 3 - 1 ∧ λ ^ 4 ∣ S.b ^ 3 + 1` or
`λ ^ 4 ∣ S.a ^ 3 + 1 ∧ λ ^ 4 ∣ S.b ^ 3 - 1`.  -/
lemma a_cube_b_cube_same_congr :
    λ ^ 4 ∣ S.a ^ 3 - 1 ∧ λ ^ 4 ∣ S.b ^ 3 + 1 ∨  λ ^ 4 ∣ S.a ^ 3 + 1 ∧ λ ^ 4 ∣ S.b ^ 3 - 1 := by
  obtain ⟨z, hz⟩ := S.hcdvd
  rcases lambda_pow_four_dvd_cube_sub_one_or_add_one_of_lambda_not_dvd hζ S.ha with
    (⟨x, hx⟩ | ⟨x, hx⟩) <;>
  rcases lambda_pow_four_dvd_cube_sub_one_or_add_one_of_lambda_not_dvd hζ S.hb with
    (⟨y, hy⟩ | ⟨y, hy⟩)
  · exfalso
    refine lambda_not_dvd_two hζ ⟨S.u * λ ^ 2 * z ^ 3 - λ ^ 3 * (x + y), ?_⟩
    symm
    calc _ = S.u * (λ * z) ^ 3 - λ ^ 4 * x - λ ^ 4 * y := by ring
    _ = (S.a ^ 3 + S.b ^ 3) - (S.a ^ 3 - 1) - (S.b ^ 3 - 1) := by rw [← hx, ← hy, ← hz, ← S.H]
    _ = 2 := by ring
  · left
    exact ⟨⟨x, hx⟩, ⟨y, hy⟩⟩
  · right
    exact ⟨⟨x, hx⟩, ⟨y, hy⟩⟩
  · exfalso
    refine lambda_not_dvd_two hζ ⟨λ ^ 3 * (x + y) - S.u * λ ^ 2 * z ^ 3, ?_⟩
    symm
    calc _ =  λ ^ 4 * x + λ ^ 4 * y - S.u * (λ * z) ^ 3 := by ring
    _ = (S.a ^ 3 + 1) + (S.b ^ 3 + 1) - (S.a ^ 3 + S.b ^ 3) := by rw [← hx, ← hy, ← hz, ← S.H]
    _ = 2 := by ring

/-- Given `S : Solution'`, we have that `λ ^ 4` divides `S.c ^ 3`. -/
lemma lambda_pow_four_dvd_c_cube : λ ^ 4 ∣ S.c ^ 3 := by
  rcases a_cube_b_cube_same_congr S with
    (⟨⟨x, hx⟩, ⟨y, hy⟩⟩ | ⟨⟨x, hx⟩, ⟨y, hy⟩⟩) <;> {
  refine ⟨S.u⁻¹ * (x + y), ?_⟩
  symm
  calc _ = S.u⁻¹ * (λ ^ 4 * x + λ ^ 4 * y) := by ring
  _ = S.u⁻¹ * (S.a ^ 3 + S.b ^ 3) := by rw [← hx, ← hy]; ring
  _ = S.u⁻¹ * (S.u * S.c ^ 3) := by rw [S.H]
  _ = S.c ^ 3 := by simp }

/-- Given `S : Solution'`, we have that `λ ^ 2` divides `S.c`. -/
lemma lambda_pow_two_dvd_c : λ ^ 2 ∣ S.c := by
  classical
  have  hm := S.multiplicity_lambda_c_finite
  suffices 2 ≤ (multiplicity ((hζ.toInteger - 1)) S.c).get hm by
    obtain ⟨x, hx⟩ := multiplicity.pow_multiplicity_dvd hm
    refine ⟨λ ^ ((multiplicity ((hζ.toInteger - 1)) S.c).get hm - 2) * x, ?_⟩
    rw [← mul_assoc, ← pow_add]
    convert hx using 3
    simp [this]
  have := lambda_pow_four_dvd_c_cube S
  have hm1 :(multiplicity (hζ.toInteger - 1) (S.c ^ 3)).get
    (multiplicity.finite_pow hζ.lambda_prime hm) =
    multiplicity (hζ.toInteger - 1) (S.c ^ 3) := by simp
  rw [multiplicity.pow_dvd_iff_le_multiplicity, ← hm1, multiplicity.pow' hζ.lambda_prime hm,
    Nat.cast_ofNat, Nat.ofNat_le_cast] at this
  linarith

/-- Given `S : Solution'`, we have that `2 ≤ S.multiplicity`. -/
lemma Solution'.two_le_multiplicity : 2 ≤ S.multiplicity := by
  simpa [← PartENat.coe_le_coe, Solution'.multiplicity] using
    multiplicity.le_multiplicity_of_pow_dvd (lambda_pow_two_dvd_c S)

/-- Given `S : Solution`, we have that `2 ≤ S.multiplicity`. -/
lemma Solution.two_le_multiplicity (S : Solution) : 2 ≤ S.multiplicity := by
  exact S.toSolution'.two_le_multiplicity

/-- Given `S : Solution'`, the key factorization of `S.a ^ 3 + S.b ^ 3`. -/
lemma cube_add_cube_eq_mul :
    S.a ^ 3 + S.b ^ 3 = (S.a + S.b) * (S.a + η * S.b) * (S.a + η ^ 2 * S.b) := by
  symm
  calc _ = S.a^3+S.a^2*S.b*(η^2+η+1)+S.a*S.b^2*(η^2+η+η^3)+η^3*S.b^3 := by ring
  _ = S.a^3+S.a^2*S.b*(η^2+η+1)+S.a*S.b^2*(η^2+η+1)+S.b^3 :=
    by rw [hζ.toInteger_cube_eq_one, one_mul]
  _ = S.a ^ 3 + S.b ^ 3 := by rw [hζ.toInteger_eval_cyclo]; ring

open PartENat in

/-- Given `S : Solution'`, we have that `λ ^ 2` divides one amongst `S.a + S.b`,
`S.a + η * S.b` and `S.a + η ^ 2 * S.b`. -/
lemma lambda_sq_dvd_or_dvd_or_dvd :
    λ ^ 2 ∣ S.a + S.b ∨ λ ^ 2 ∣ S.a + η * S.b ∨ λ ^ 2 ∣ S.a + η ^ 2 * S.b := by
  classical
  by_contra! h
  rcases h with ⟨h1, h2, h3⟩
  rw [← multiplicity.multiplicity_lt_iff_not_dvd] at h1 h2 h3
  have h1' : multiplicity.Finite (hζ.toInteger - 1) (S.a + S.b) :=
    multiplicity.ne_top_iff_finite.1 (fun ht ↦ by simp [ht] at h1)
  have h2' : multiplicity.Finite (hζ.toInteger - 1) (S.a + η * S.b) :=
    multiplicity.ne_top_iff_finite.1 (fun ht ↦ by simp [ht] at h2)
  have h3' : multiplicity.Finite (hζ.toInteger - 1) (S.a + η ^ 2 * S.b) :=
    multiplicity.ne_top_iff_finite.1 (fun ht ↦ by simp [ht] at h3)
  replace h1' : (multiplicity (hζ.toInteger - 1) (S.a + S.b)).get h1' =
    multiplicity (hζ.toInteger - 1) (S.a + S.b) := by simp
  replace h2' : (multiplicity (hζ.toInteger - 1) (S.a + η * S.b)).get h2' =
    multiplicity (hζ.toInteger - 1) (S.a + η * S.b) := by simp
  replace h3' : (multiplicity (hζ.toInteger - 1) (S.a + η ^ 2 * S.b)).get h3' =
    multiplicity (hζ.toInteger - 1) (S.a + η ^ 2 * S.b) := by simp
  rw [← h1', coe_lt_coe] at h1; rw [← h2', coe_lt_coe] at h2; rw [← h3', coe_lt_coe] at h3
  have := (pow_dvd_pow_of_dvd (lambda_pow_two_dvd_c S) 3).mul_left S.u
  rw [← pow_mul, ← S.H, cube_add_cube_eq_mul, multiplicity.pow_dvd_iff_le_multiplicity,
    multiplicity.mul hζ.zeta_sub_one_prime', multiplicity.mul (IsPrimitiveRoot.lambda_prime hζ), ← h1', ← h2',
    ← h3', ← Nat.cast_add, ← Nat.cast_add, coe_le_coe] at this
  linarith

/-- Given `S : Solution'`, we may assume that `λ ^ 2` divides `S.a + S.b` (see also the
result below). -/
lemma ex_dvd_a_add_b : ∃ (a' b' : 𝓞 K), a' ^ 3 + b' ^ 3 = S.u * S.c ^ 3 ∧
    IsCoprime a' b' ∧ ¬ λ ∣ a' ∧ ¬ λ ∣ b' ∧ λ ^ 2 ∣ a' + b' := by
  rcases lambda_sq_dvd_or_dvd_or_dvd S with (h | h | h)
  · exact ⟨S.a, S.b, S.H, S.coprime, S.ha, S.hb, h⟩
  · refine ⟨S.a, η * S.b, ?_, ?_, S.ha, fun ⟨x, hx⟩ ↦ S.hb ⟨η ^ 2 * x, ?_⟩, h⟩
    · rw [mul_pow, hζ.toInteger_cube_eq_one, one_mul, S.H]
    · exact (isCoprime_mul_unit_left_right hζ.eta_isUnit _ _).2 S.coprime
    · rw [mul_comm _ x, ← mul_assoc, ← hx, mul_comm _ S.b, mul_assoc, ← pow_succ',
        hζ.toInteger_cube_eq_one, mul_one]
  · refine ⟨S.a, η ^ 2 * S.b, ?_, ?_, S.ha, fun ⟨x, hx⟩ ↦ S.hb ⟨η * x, ?_⟩, h⟩
    · rw [mul_pow, ← pow_mul, mul_comm 2, pow_mul, hζ.toInteger_cube_eq_one, one_pow, one_mul, S.H]
    · exact (isCoprime_mul_unit_left_right (hζ.eta_isUnit.pow _) _ _).2 S.coprime
    · rw [mul_comm _ x, ← mul_assoc, ← hx, mul_comm _ S.b, mul_assoc, ← pow_succ,
        hζ.toInteger_cube_eq_one, mul_one]

/-- Given `S : Solution'`, then there is `S₁ : Solution` such that
`S₁.multiplicity = S.multiplicity`. -/
lemma exists_Solution_of_Solution' : ∃ (S₁ : Solution), S₁.multiplicity = S.multiplicity := by
  obtain ⟨a, b, H, coprime, ha, hb, hab⟩ := ex_dvd_a_add_b S
  exact ⟨
  { a := a
    b := b
    c := S.c
    u := S.u
    ha := ha
    hb := hb
    hc := S.hc
    coprime := coprime
    hcdvd := S.hcdvd
    H := H
    hab := hab }, rfl⟩

end Solution'

namespace Solution

variable (S : Solution)

/-- Given `S : Solution`, we have that `S.a + η * S.b = (S.a + S.b) + λ * S.b`. -/
lemma a_add_eta_b : S.a + η * S.b = (S.a + S.b) + λ * S.b := by ring

/-- Given `S : Solution`, we have that `λ ∣ (S.a + η * S.b)`. -/
lemma lambda_dvd_a_add_eta_mul_b : λ ∣ (S.a + η * S.b) := by
  rw [a_add_eta_b]
  exact dvd_add (dvd_trans (dvd_pow_self _ (by decide)) S.hab) ⟨S.b, by rw [mul_comm]⟩

/-- Given `S : Solution`, we have that `λ ∣ (S.a + η ^ 2 * S.b)`. -/
lemma lambda_dvd_a_add_eta_sq_mul_b : λ ∣ (S.a + η ^ 2 * S.b) := by
  rw [show S.a + η ^ 2 * S.b = (S.a + S.b) + λ ^ 2 * S.b + 2 * λ * S.b by ring]
  exact dvd_add (dvd_add (dvd_trans (dvd_pow_self _ (by decide)) S.hab) ⟨λ * S.b, by ring⟩)
    ⟨2 * S.b, by ring⟩

/-- Given `S : Solution`, we have that `λ ^ 2` does not divide `S.a + η * S.b`. -/
lemma lambda_sq_not_dvd_a_add_eta_mul_b : ¬ λ ^ 2 ∣ (S.a + η * S.b) := by
  simp_rw [a_add_eta_b, dvd_add_right S.hab, pow_two, mul_dvd_mul_iff_left (lambda_ne_zero hζ),
  S.hb, not_false_eq_true]

/-- Given `S : Solution`, we have that `λ ^ 2` does not divide `S.a + η ^ 2 * S.b`. -/
lemma lambda_sq_not_dvd_a_add_eta_sq_mul_b : ¬ λ ^ 2 ∣ (S.a + η ^ 2 * S.b) := by
  intro h
  apply S.hb
  rcases h with ⟨k, hk⟩
  rw [show S.a + η ^ 2 * S.b = S.a + S.b - S.b + η ^ 2 * S.b by ring] at hk
  rcases S.hab with ⟨k', hk'⟩
  use (k - k') * (-η)
  rw [hk'] at hk
  rw [show λ ^ 2 * k' - S.b + η ^ 2 * S.b = λ * (S.b * (η +1) + λ * k') by ring,
    pow_two, mul_assoc] at hk
  simp only [mul_eq_mul_left_iff, lambda_ne_zero, or_false] at hk
  replace hk := congr_arg (fun x => x * (-η)) hk
  simp only at hk
  rw [show (S.b * (η + 1) + λ * k') * -η = (- S.b) * (η ^ 2 + η + 1 - 1) - η * λ * k' by ring] at hk
  rw [hζ.toInteger_eval_cyclo] at hk
  simp only [zero_sub, mul_neg, mul_one, neg_neg] at hk
  rw [sub_eq_iff_eq_add] at hk
  rw [hk]
  ring

/-- Given `S : Solution`, we have that `(η + 1) * (-η) = 1`. -/
lemma eta_add_one_inv : (η + 1) * (-η) = 1 := by
  calc (η + 1) * -η = -(η ^ 2 + η + 1) + 1  := by ring
  _ = 1 := by rw [hζ.toInteger_eval_cyclo]; simp

/-- If `p : 𝓞 K` is a prime that divides both `S.a + S.b` and `S.a + η * S.b`, then `p`
is associated with `λ`. -/
lemma associated_of_dvd_a_add_b_of_dvd_a_add_eta_mul_b {p : 𝓞 K} (hp : Prime p)
    (hpab : p ∣ S.a + S.b) (hpaetab : p ∣ S.a + η * S.b) : Associated p λ := by
  by_cases p_lam : (p ∣ λ)
  · exact hp.associated_of_dvd hζ.lambda_prime p_lam
  have pdivb : p ∣ S.b := by
    have fgh : p ∣ (λ * S.b) := by
      rw [show λ * S.b = (S.a + η * S.b) - (S.a + S.b) by ring]
      exact dvd_sub hpaetab hpab
    rcases Prime.dvd_or_dvd hp fgh with (h | h)
    · contradiction
    · exact h
  have pdiva : p ∣ S.a := by
    have fgh : p ∣ (λ * S.a) := by
      rw [show λ * S.a = η * (S.a + S.b) - (S.a + η * S.b) by ring]
      exact dvd_sub (dvd_mul_of_dvd_right hpab _) hpaetab
    rcases Prime.dvd_or_dvd hp fgh with (h | h)
    · tauto
    · exact h
  have punit := IsCoprime.isUnit_of_dvd' S.coprime pdiva pdivb
  exfalso
  exact hp.not_unit punit

/-- If `p : 𝓞 K` is a prime that divides both `S.a + S.b` and `S.a + η ^ 2 * S.b`, then `p`
is associated with `λ`. -/
lemma associated_of_dvd_a_add_b_of_dvd_a_add_eta_sq_mul_b {p : 𝓞 K} (hp : Prime p)
  (hpab : p ∣ (S.a + S.b)) (hpaetasqb : p ∣ (S.a + η ^ 2 * S.b)) : Associated p λ := by
  by_cases p_lam : (p ∣ λ)
  · exact hp.associated_of_dvd hζ.lambda_prime p_lam
  have pdivb : p ∣ S.b := by
    have fgh : p ∣ λ * S.b := by
      rw [show λ * S.b = - (1 - η) * S.b by ring, ← hζ.toInteger_cube_eq_one]
      rw [show - (η ^ 3 - η) * S.b = η * ((S.a + S.b) - (S.a + η ^ 2 * S.b)) by ring]
      rw [hζ.eta_isUnit.dvd_mul_left]
      exact hpab.sub hpaetasqb
    exact hp.dvd_or_dvd fgh |>.resolve_left p_lam
  have pdiva : p ∣ S.a := by
    have fgh : p ∣ λ * S.a := by
      rw [show λ * S.a = - (1 - η) * S.a by ring, ← hζ.toInteger_cube_eq_one]
      rw [show - (η ^ 3 - η) * S.a = η * ((S.a + η ^ 2 * S.b) - η ^ 2 * (S.a + S.b)) by ring]
      rw [hζ.eta_isUnit.dvd_mul_left]
      exact hpaetasqb.sub (dvd_mul_of_dvd_right hpab _)
    exact hp.dvd_or_dvd fgh |>.resolve_left p_lam
  have punit := S.coprime.isUnit_of_dvd' pdiva pdivb
  exact hp.not_unit punit |>.elim

/-- If `p : 𝓞 K` is a prime that divides both `S.a + η * S.b` and `S.a + η ^ 2 * S.b`, then `p`
is associated with `λ`. -/
lemma associated_of_dvd_a_add_eta_mul_b_of_dvd_a_add_eta_sq_mul_b {p : 𝓞 K} (hp : Prime p)
    (hpaetab : p ∣ S.a + η * S.b) (hpaetasqb : p ∣ S.a + η ^ 2 * S.b) : Associated p λ := by
  by_cases p_lam : (p ∣ λ)
  · exact hp.associated_of_dvd hζ.lambda_prime p_lam
  have pdivb : p ∣ S.b := by
    have fgh : p ∣ η * (λ * S.b) := by
      rw [show η * (λ * S.b) = (S.a + η ^ 2 * S.b) - (S.a + η * S.b) by ring]
      exact hpaetasqb.sub hpaetab
    rw [hζ.eta_isUnit.dvd_mul_left] at fgh
    exact hp.dvd_or_dvd fgh |>.resolve_left p_lam
  have pdiva : p ∣ S.a := by
    have fgh : p ∣ λ * S.a := by
      rw [show λ * S.a = η * (S.a + η * S.b) - (S.a + η ^ 2 * S.b) by ring]
      exact dvd_mul_of_dvd_right hpaetab _ |>.sub hpaetasqb
    exact hp.dvd_or_dvd fgh |>.resolve_left p_lam
  have punit := S.coprime.isUnit_of_dvd' pdiva pdivb
  exact hp.not_unit punit |>.elim

/-- Given `S : Solution`, we let `S.y` be the element such that
`S.a + η * S.b = λ * S.y`. -/
noncomputable
def y := (lambda_dvd_a_add_eta_mul_b S).choose

/-- Given `S : Solution` and `S.y`, then `S.a + η * S.b = λ * S.y`. -/
lemma y_spec : S.a + η * S.b = λ * S.y :=
  (lambda_dvd_a_add_eta_mul_b S).choose_spec

/-- Given `S : Solution`, we let `S.z` be the element such that
`S.a + η ^ 2 * S.b = λ * S.z`. -/
noncomputable
def z := (lambda_dvd_a_add_eta_sq_mul_b S).choose

/-- Given `S : Solution` and `S.z`, then `S.a + η ^ 2 * S.b = λ * S.z`. -/
lemma z_spec : S.a + η ^ 2 * S.b = λ * S.z :=
  (lambda_dvd_a_add_eta_sq_mul_b S).choose_spec

/-- Given `S : Solution`, `λ` does not divide `S.y`. -/
lemma lambda_not_dvd_y : ¬ λ ∣ S.y := by
  intro h
  replace h := mul_dvd_mul_left (η - 1) h
  rw [← y_spec] at h
  rw [← pow_two] at h
  exact lambda_sq_not_dvd_a_add_eta_mul_b _ h

/-- Given `S : Solution`, `λ` does not divide `S.z`. -/
lemma lambda_not_dvd_z : ¬ λ ∣ S.z := by
  intro h
  replace h := mul_dvd_mul_left (η - 1) h
  rw [← z_spec] at h
  rw [← pow_two] at h
  exact lambda_sq_not_dvd_a_add_eta_sq_mul_b _ h

/-- Given `S : Solution`, we have that `λ ^ (3*S.multiplicity-2)` divides `S.a + S.b`. -/
lemma lambda_pow_dvd_a_add_b : λ ^ (3 * S.multiplicity - 2) ∣ S.a + S.b := by
  have h : λ ^ S.multiplicity ∣ S.c  := multiplicity.pow_multiplicity_dvd _
  replace h := pow_dvd_pow_of_dvd h 3
  replace h : (λ ^ S.multiplicity) ^ 3 ∣ S.u * S.c ^ 3 := by simp [h]
  have := S.two_le_multiplicity
  have hh : 3 * S.multiplicity - 2 + 1 + 1 = 3 * S.multiplicity := by
    omega
  rw [← S.H, cube_add_cube_eq_mul, ← pow_mul,
    mul_comm, y_spec, z_spec, ← hh, pow_succ, pow_succ] at h
  apply hζ.lambda_prime.pow_dvd_of_dvd_mul_left _ S.lambda_not_dvd_z
  apply hζ.lambda_prime.pow_dvd_of_dvd_mul_left _ S.lambda_not_dvd_y
  rw [show (S.a + S.b) * (λ * y S) * (λ * z S) = (S.a + S.b) * y S * z S * λ * λ by ring] at h
  simp only [mul_dvd_mul_iff_right (lambda_ne_zero hζ)] at h
  rwa [show (S.a + S.b) * y S * z S = y S * (z S * (S.a + S.b)) by ring] at h

/-- Given `S : Solution`, we let `S.x` be the element such that
`S.a + S.b = λ ^ (3*S.multiplicity-2) * S.x` -/
noncomputable
def x := (lambda_pow_dvd_a_add_b S).choose

/-- Given `S : Solution` and `S.x`, then `S.a + S.b = λ ^ (3*S.multiplicity-2) * S.x`. -/
lemma x_spec : S.a + S.b = λ ^ (3*S.multiplicity-2) * S.x :=
  (lambda_pow_dvd_a_add_b S).choose_spec

/-- Given `S : Solution`, we let `S.w` be the element such that
`S.c = λ ^ S.multiplicity * S.w` -/
noncomputable
def w :=
  (multiplicity.pow_multiplicity_dvd S.toSolution'.multiplicity_lambda_c_finite).choose

/-- Given `S : Solution` and `S.w`, then `S.c = λ ^ S.multiplicity * S.w`. -/
lemma w_spec : S.c = λ ^ S.multiplicity * S.w :=
(multiplicity.pow_multiplicity_dvd S.toSolution'.multiplicity_lambda_c_finite).choose_spec

/-- Given `S : Solution`, `λ` does not divide `S.w`. -/
lemma lambda_not_dvd_w : ¬ λ ∣ S.w := by
  intro h
  replace h := mul_dvd_mul_left (λ ^ S.multiplicity) h
  rw [← w_spec] at h
  have hh : _ := multiplicity.is_greatest' S.toSolution'.multiplicity_lambda_c_finite (lt_add_one S.multiplicity)
  rw [pow_succ', mul_comm] at hh
  exact hh h

/-- Given `S : Solution`, we have that `λ` does not divide `S.x`. -/
lemma lambda_not_dvd_x : ¬ λ ∣ S.x := by
  intro h
  replace h := mul_dvd_mul_left (λ ^ (3 * S.multiplicity - 2)) h
  rw [mul_comm, ← x_spec] at h
  replace h := mul_dvd_mul (mul_dvd_mul h S.lambda_dvd_a_add_eta_mul_b) S.lambda_dvd_a_add_eta_sq_mul_b
  rw [← cube_add_cube_eq_mul, S.H, w_spec] at h
  simp only [Units.isUnit, IsUnit.dvd_mul_left] at h
  rw [← pow_succ', mul_comm, ← mul_assoc, ← pow_succ'] at h
  have := S.two_le_multiplicity
  have hh : 3 * S.multiplicity - 2 + 1 + 1 = 3 * S.multiplicity := by
    omega
  rw [hh, mul_pow, ← pow_mul, mul_comm _ 3, mul_dvd_mul_iff_left _] at h
  · replace h := Prime.dvd_of_dvd_pow hζ.lambda_prime h
    exact lambda_not_dvd_w _ h
  · simp [lambda_ne_zero]

/-- Given `S : Solution`, we have that `S.x` and `S.y` are coprime. -/
lemma coprime_x_y : IsCoprime S.x S.y := by
  apply isCoprime_of_prime_dvd
  · simp only [not_and]
    intro _  hy
    apply lambda_not_dvd_y S
    simp [hy]
  · intro p hp p_dvd_x p_dvd_y
    have aux1 := dvd_mul_of_dvd_right p_dvd_x (λ ^ (3 * S.multiplicity - 2))
    rw [← x_spec] at aux1
    have aux2 := dvd_mul_of_dvd_right p_dvd_y (η - 1)
    rw [← y_spec] at aux2
    have aux3 : Associated p (η - 1) := by
      apply associated_of_dvd_a_add_b_of_dvd_a_add_eta_mul_b
      exact hp
      exact aux1
      exact aux2
    have aux4 : λ ∣ S.x := by
      rw [← Associated.dvd_iff_dvd_left aux3]
      exact p_dvd_x
    apply lambda_not_dvd_x
    exact aux4

/-- Given `S : Solution`, we have that `S.x` and `S.z` are coprime. -/
lemma coprime_x_z : IsCoprime S.x S.z := by
  apply isCoprime_of_prime_dvd
  . simp only [not_and]
    intro _ hz
    apply lambda_not_dvd_z S
    simp [hz]
  . intro p hp p_dvd_x p_dvd_z
    have aux1 := dvd_mul_of_dvd_right p_dvd_x (λ ^ (3 * S.multiplicity - 2))
    rw [← x_spec] at aux1
    have aux2 := dvd_mul_of_dvd_right p_dvd_z (η - 1)
    rw [← z_spec] at aux2
    have aux3 : Associated p (η - 1) := by
      apply associated_of_dvd_a_add_b_of_dvd_a_add_eta_sq_mul_b
      exact hp
      exact aux1
      exact aux2
    have aux4 : λ ∣ S.x := by
      rw [← Associated.dvd_iff_dvd_left aux3]
      exact p_dvd_x
    apply lambda_not_dvd_x
    exact aux4

/-- Given `S : Solution`, we have that `S.y` and `S.z` are coprime. -/
lemma coprime_y_z : IsCoprime S.y S.z := by
  apply isCoprime_of_prime_dvd
  . simp only [not_and]
    intro _ hz
    apply lambda_not_dvd_z S
    simp [hz]
  . intro p hp p_dvd_y p_dvd_z
    have aux1 := dvd_mul_of_dvd_right p_dvd_y (η - 1)
    rw [← y_spec] at aux1
    have aux2 := dvd_mul_of_dvd_right p_dvd_z (η - 1)
    rw [← z_spec] at aux2
    have aux3 : Associated p (η - 1) := by
      apply associated_of_dvd_a_add_eta_mul_b_of_dvd_a_add_eta_sq_mul_b
      exact hp
      exact aux1
      exact aux2
    have aux4 : λ ∣ S.y := by
      rw [← Associated.dvd_iff_dvd_left aux3]
      exact p_dvd_y
    apply lambda_not_dvd_y
    exact aux4

/-- Given `S : Solution`, we have that `3 * S.multiplicity - 2 + 1 + 1 = 3 * S.multiplicity`. -/
lemma mult_minus_two_plus_one_plus_one : 3 * S.multiplicity - 2 + 1 + 1 = 3 * S.multiplicity := by
  have this : 2 ≤ 3 * S.multiplicity := by
    linarith [two_le_multiplicity S]
  zify [this]
  ring

/-- Given `S : Solution`, we have that `S.x * S.y * S.z = S.u * S.w ^ 3`. -/
lemma x_mul_y_mul_z_eq_u_w_pow_three : S.x * S.y * S.z = S.u * S.w ^ 3 := by
  suffices hh : λ ^ (3 * S.multiplicity - 2) * S.x * λ * S.y * λ * S.z = S.u * λ ^ (3 * S.multiplicity) * S.w ^ 3 by
    rw [show λ ^ (3 * S.multiplicity - 2) * x S * λ * y S * λ * z S = λ ^ (3 * S.multiplicity - 2) * λ * λ * x S * y S * z S by ring] at hh
    rw [mul_comm _ (λ ^ (3 * S.multiplicity))] at hh
    simp only [← pow_succ] at hh
    have := S.two_le_multiplicity
    have hhh : 3 * S.multiplicity - 2 + 1 + 1 = 3 * S.multiplicity := by
      omega
    rw [hhh] at hh
    rw [mul_assoc, mul_assoc, mul_assoc] at hh
    simp [lambda_ne_zero] at hh
    convert hh using 1
    ring
  simp only [← x_spec, mul_assoc, ← y_spec, ← z_spec]
  simp only [mul_comm 3, pow_mul, ← mul_pow, ← w_spec]
  rw [← S.H, cube_add_cube_eq_mul]
  ring

/-- Given `S : Solution`, there exists `u₁` in `(𝓞 K)ˣ` and `X` in `𝓞 K`
such that  `S.x = u₁ * X ^ 3`. -/
lemma x_eq_unit_mul_cube : ∃ (u₁ : (𝓞 K)ˣ) (X : 𝓞 K), S.x = u₁ * X ^ 3 := by
  have h1 : S.x * (S.y * S.z * S.u⁻¹) = S.w ^ 3 := by
    --simp only [x_mul_y_mul_z_eq_u_w_pow_three, ← mul_assoc] --this produces a timeout error
    simp only [← mul_assoc, x_mul_y_mul_z_eq_u_w_pow_three]
    simp only [mul_comm _ (S.w ^ 3), mul_assoc,mul_right_inv, Units.mul_inv, mul_one]
  have h2 : IsCoprime S.x (S.y * S.z * S.u⁻¹) := by
    apply (isCoprime_mul_unit_right_right _ S.x _).mpr
    apply IsCoprime.mul_right S.coprime_x_y S.coprime_x_z
    simp only [Units.isUnit]
  have h3 : _ := exists_associated_pow_of_mul_eq_pow' h2 h1
  rcases h3 with ⟨X, ⟨u₁, hX⟩⟩
  use u₁; use X
  simp [← hX, mul_comm]

/-- Given `S : Solution`, there exists `u₂` in `(𝓞 K)ˣ` and `Y` in `𝓞 K`
such that  `S.y = u₂ * Y ^ 3`. -/
lemma y_eq_unit_mul_cube : ∃ (u₂ : (𝓞 K)ˣ) (Y : 𝓞 K), S.y = u₂ * Y ^ 3 := by
  have h1 : S.y * (S.x * S.z * S.u⁻¹) = S.w ^ 3 := by
    rw [← mul_assoc, ← mul_assoc S.y, mul_comm S.y, x_mul_y_mul_z_eq_u_w_pow_three]
    simp only [mul_comm _ (S.w ^ 3), mul_assoc, mul_right_inv, Units.mul_inv, mul_one]
  have h2 : IsCoprime S.y (S.x * S.z * S.u⁻¹) := by
    apply (isCoprime_mul_unit_right_right _ S.y _).mpr
    apply IsCoprime.mul_right S.coprime_x_y.symm S.coprime_y_z
    simp only [Units.isUnit]
  have h3 : _ := exists_associated_pow_of_mul_eq_pow' h2 h1
  rcases h3 with ⟨Y, ⟨u₂, hY⟩⟩
  use u₂; use Y
  simp [← hY, mul_comm]

/-- Given `S : Solution`, there exists `u₃` in `(𝓞 K)ˣ` and `Z` in `𝓞 K`
such that  `S.z = u₃ * Z ^ 3`. -/
lemma z_eq_unit_mul_cube : ∃ (u₃ : (𝓞 K)ˣ) (Z : 𝓞 K), S.z = u₃ * Z ^ 3 := by
  have h1 : S.z * (S.x * S.y * S.u⁻¹) = S.w ^ 3 := by
    rw [← mul_assoc, ← mul_assoc S.z, mul_comm S.z, mul_assoc S.x, mul_comm S.z, ← mul_assoc, x_mul_y_mul_z_eq_u_w_pow_three]
    simp only [mul_comm _ (S.w ^ 3), mul_assoc, mul_right_inv, Units.mul_inv, mul_one]
  have h2 : IsCoprime S.z (S.x * S.y * S.u⁻¹) := by
    apply (isCoprime_mul_unit_right_right _ S.z _).mpr
    apply IsCoprime.mul_right S.coprime_x_z.symm S.coprime_y_z.symm
    simp only [Units.isUnit]
  have h3 : _ := exists_associated_pow_of_mul_eq_pow' h2 h1
  rcases h3 with ⟨Z, ⟨u₃, hZ⟩⟩
  use u₃; use Z
  simp [← hZ, mul_comm]

/-- Given `S : Solution`, we let `S.u₁` and `S.X` be the elements such that
`S.x = S.u₁ * S.X ^ 3` -/
noncomputable
def u₁ := (x_eq_unit_mul_cube S).choose

/-- Given `S : Solution`, we let `S.u₁` and `S.X` be the elements such that
`S.x = S.u₁ * S.X ^ 3` -/
noncomputable
def X := (x_eq_unit_mul_cube S).choose_spec.choose

/-- Given `S : Solution`, `S.u₁` and `S.X`, we have that `S.x = S.u₁ * S.X ^ 3`. -/
lemma u₁_X_spec : S.x = S.u₁ * S.X ^ 3 := by
  exact (x_eq_unit_mul_cube S).choose_spec.choose_spec

/-- Given `S : Solution`, we let `S.u₂` and `S.Y` be the elements such that
`S.y = S.u₂ * S.Y ^ 3` -/
noncomputable
def u₂ := (y_eq_unit_mul_cube S).choose

/-- Given `S : Solution`, we let `S.u₂` and `S.Y` be the elements such that
`S.y = S.u₂ * S.Y ^ 3` -/
noncomputable
def Y := (y_eq_unit_mul_cube S).choose_spec.choose

/-- Given `S : Solution`, `S.u₂` and `S.Y`, we have that `S.y = S.u₂ * S.Y ^ 3`. -/
lemma u₂_Y_spec : S.y = S.u₂ * S.Y ^ 3 := by
  exact (y_eq_unit_mul_cube S).choose_spec.choose_spec

/-- Given `S : Solution`, we let `S.u₃` and `S.Z` be the elements such that
`S.z = S.u₃ * S.Z ^ 3` -/
noncomputable
def u₃ := (z_eq_unit_mul_cube S).choose

/-- Given `S : Solution`, we let `S.u₃` and `S.Z` be the elements such that
`S.z = S.u₃ * S.Z ^ 3` -/
noncomputable
def Z := (z_eq_unit_mul_cube S).choose_spec.choose

/-- Given `S : Solution`, `S.u₃` and `S.Z`, we have that `S.z = S.u₃ * S.Z ^ 3`. -/
lemma u₃_Z_spec : S.z = S.u₃ * S.Z ^ 3 := by
  exact (z_eq_unit_mul_cube S).choose_spec.choose_spec

/-- Given `S : Solution`, we have that `S.X ≠ 0`. -/
lemma X_ne_zero : S.X ≠ 0 := by
  intro h
  have aux1 : S.x = 0 := by
    rw [u₁_X_spec, h]
    ring
  have aux2 : λ ∣ S.x := by simp [aux1]
  apply lambda_not_dvd_x S
  exact aux2

/-- Given `S : Solution`, we have that `λ` does not divide `S.X`. -/
lemma lambda_not_dvd_X : ¬ λ ∣ S.X := by
  intro h
  have hyp := dvd_mul_of_dvd_right h (S.u₁ * S.X ^ 2)
  rw [show ↑(u₁ S) * X S ^ 2 * X S = ↑S.u₁ * S.X^3 by ring] at hyp
  rw [← u₁_X_spec] at hyp
  apply lambda_not_dvd_x S
  simp [hyp]

/-- Given `S : Solution`, we have that `λ` does not divide `S.Y`. -/
lemma lambda_not_dvd_Y : ¬ λ ∣ S.Y := by
  intro h
  have hyp := dvd_mul_of_dvd_right h (S.u₂ * S.Y^2)
  rw [show ↑(u₂ S) * Y S ^ 2 * Y S = ↑S.u₂ * S.Y^3 by ring] at hyp
  rw [← u₂_Y_spec] at hyp
  apply lambda_not_dvd_y S
  simp [hyp]

/-- Given `S : Solution`, we have that `λ` does not divide `S.Z`. -/
lemma lambda_not_dvd_Z : ¬ λ ∣ S.Z := by
  intro h
  have hyp := dvd_mul_of_dvd_right h (S.u₃ * S.Z^2)
  rw [show ↑(u₃ S) * Z S ^ 2 * Z S = ↑S.u₃ * S.Z^3 by ring] at hyp
  rw [← u₃_Z_spec] at hyp
  apply lambda_not_dvd_z S
  simp [hyp]

/-- Given `S : Solution`, we have that `S.Y` and `S.Z` are coprime. -/
lemma coprime_Y_Z : IsCoprime S.Y S.Z := by
  apply isCoprime_of_prime_dvd
  · simp only [not_and]
    intro _ hy_Z_zero
    apply lambda_not_dvd_Z S
    simp only [hy_Z_zero, dvd_zero]
  · intro p hp p_dvd_Y p_dvd_Z
    have auxY := dvd_mul_of_dvd_right p_dvd_Y (S.u₂ * S.Y^2)
    rw [show S.u₂ * S.Y^2 * S.Y = S.u₂ * S.Y^3 by ring] at auxY
    rw [← u₂_Y_spec] at auxY
    have auxZ := dvd_mul_of_dvd_right p_dvd_Z (S.u₃ * S.Z^2)
    rw [show S.u₃ * S.Z^2 * S.Z = S.u₃ * S.Z^3 by ring] at auxZ
    rw [← u₃_Z_spec] at auxZ
    have gcd_isUnit : IsUnit (gcd S.y S.z) := by
      rw [gcd_isUnit_iff S.y S.z]
      simp only [coprime_y_z]
    apply hp.not_unit
    refine isUnit_of_dvd_unit ?_ gcd_isUnit
    rw [dvd_gcd_iff]
    simp [auxY, auxZ]

/-- Given `S : Solution`, we have that
`S.u₁*S.X^3*λ^(3*S.multiplicity-2)+S.u₂*η*S.Y^3*λ+S.u₃*η^2*S.Z^3*λ = 0`. -/
lemma formula1 : S.u₁*S.X^3*λ^(3*S.multiplicity-2)+S.u₂*η*S.Y^3*λ+S.u₃*η^2*S.Z^3*λ = 0 := by
  rw [← u₁_X_spec, ← mul_comm η _, mul_assoc η _ _, ← u₂_Y_spec, ← mul_comm (η ^ 2) _, mul_assoc (η ^ 2) _ _, ← u₃_Z_spec]
  rw [mul_comm, mul_assoc, ← x_spec]
  rw [mul_comm, mul_comm _ λ, ← y_spec, mul_comm _ η]
  rw [mul_assoc, mul_comm _ λ, ← z_spec]
  rw [show S.a + S.b + η * (S.a + η * S.b) + η ^ 2 * (S.a + η ^ 2 * S.b) = S.a * (1 + η + η ^ 2) + S.b * (1 + (η ^ 3) * η + η ^ 2) by ring]
  rw [hζ.toInteger_cube_eq_one, one_mul, ← add_mul]
  convert mul_zero _
  convert hζ.toInteger_eval_cyclo using 1
  ring

/-- Given `S : Solution`, we let `S.u₄'` be `η * S.u₃ * S.u₂⁻¹`. -/
noncomputable
def u₄' := η * S.u₃ * S.u₂⁻¹

/-- Given `S : Solution`, we have that `S.u₄'` is a unit. -/
lemma u₄'_isUnit : IsUnit S.u₄' := by
  unfold u₄'
  simp only [Units.isUnit_mul_units]
  exact hζ.eta_isUnit

/-- Given `S : Solution`, we let `u₄` be the element of the group of units
corresponding to the unit `u₄'`. -/
noncomputable
def u₄ := (u₄'_isUnit S).unit

/-- Given `S : Solution`, we let `S.u₅'` be `-η ^ 2 * S.u₁ * S.u₂⁻¹`. -/
noncomputable
def u₅' := -η ^ 2 * S.u₁ * S.u₂⁻¹

/-- Given `S : Solution`, we have that `S.u₅'` is a unit. -/
lemma u₅'_isUnit : IsUnit S.u₅' := by
  unfold u₅'
  rw [IsUnit.mul_iff, IsUnit.mul_iff]
  have minus_eta_sq_is_unit : IsUnit (- η ^ 2) := by
    apply isUnit_iff_exists_inv.2
    use (-η)
    ring_nf
    exact hζ.toInteger_cube_eq_one
  constructor
  · constructor
    · exact minus_eta_sq_is_unit
    · simp only [Units.isUnit]
  · simp only [Units.isUnit]

/-- Given `S : Solution`, we let `u₅` be the element of the group of units
corresponding to the unit `u₅'`. -/
noncomputable
def u₅ := (u₅'_isUnit S).unit

/-- Given `S : Solution`, we have that
`S.Y ^ 3 + S.u₄ * S.Z ^ 3 = S.u₅ * (λ ^ (S.multiplicity - 1) * S.X) ^ 3`. -/
lemma formula2 : S.Y ^ 3 + S.u₄ * S.Z ^ 3 = S.u₅ * (λ ^ (S.multiplicity - 1) * S.X) ^ 3 := by
  simp_rw [u₄, u₅, IsUnit.unit_spec]
  unfold u₄'
  unfold u₅'
  apply mul_left_cancel₀ S.u₂.isUnit.ne_zero
  apply mul_left_cancel₀ hζ.eta_isUnit.ne_zero
  apply mul_left_cancel₀ (lambda_ne_zero hζ)
  rw [show λ * (η * (↑(u₂ S) * (Y S ^ 3 + η * ↑(u₃ S) * ↑(u₂ S)⁻¹ * Z S ^ 3)))
    = λ * η * ↑(u₂ S) * Y S ^ 3 + λ * η^2 * ↑(u₂ S) * ↑(u₂ S)⁻¹ * ↑(u₃ S) * Z S ^ 3 by ring]
  rw [show λ * (η * (↑(u₂ S) * (-η ^ 2 * ↑(u₁ S) * ↑(u₂ S)⁻¹
    * (λ ^ (S.multiplicity - 1) * X S) ^ 3)))
    = λ * (↑(u₂ S) * ↑(u₂ S)⁻¹ * (-η ^ 3 * ↑(u₁ S) * (λ ^ (S.multiplicity - 1) * X S) ^ 3)) by ring]
  rw [← sub_eq_zero]
  simp only [Units.mul_inv_cancel_right, Units.mul_inv, neg_mul, mul_neg, one_mul, sub_neg_eq_add]
  rw [hζ.toInteger_cube_eq_one, one_mul]
  have tmp : λ * (↑(u₁ S) * (λ ^ (S.multiplicity - 1) * X S) ^ 3)
      = ↑(u₁ S) * X S ^ 3 * λ ^ (3 * S.multiplicity - 2) := by
    rw [mul_comm, mul_assoc, mul_assoc]
    congr 1
    rw [mul_pow, mul_comm, ← mul_assoc, mul_comm _ (S.X ^ _)]
    congr 1
    rw [← pow_mul', ← pow_succ']
    congr 1
    have := two_le_multiplicity S
    omega
  rw [tmp]
  convert formula1 S using 1
  ring

/-- Given `S : Solution`, we have that `λ^2` divides `λ^4`. -/
lemma lambda_sq_div_lambda_fourth : λ^2 ∣ λ^4 := by
  use λ^2
  ring

/-- Given `S : Solution`, we have that
`λ^2` divides `↑(u₅ S) * (λ ^ (S.multiplicity - 1) * X S) ^ 3`. -/
lemma lambda_sq_div_new_X_cubed : λ^2 ∣ ↑(u₅ S) * (λ ^ (S.multiplicity - 1) * X S) ^ 3 := by
    have := two_le_multiplicity S
    have tmp : ↑(u₅ S) * λ ^ (3 * S.multiplicity - 5) * λ^2 * S.X^3
              =
              ↑(u₅ S) * (λ ^ (S.multiplicity - 1) * X S) ^ 3 := by
      rw [mul_comm, mul_assoc, mul_pow, ← mul_assoc _ _ (S.X ^ 3), mul_comm _ (S.X ^ 3)]
      congr 2
      rw [← pow_mul, ← pow_add]
      congr 1
      omega
    rw [← tmp]
    use S.u₅ * (λ ^ (3* S.multiplicity - 5) * X S^ 3)
    ring

/-- Given `S : Solution`, we have that `↑S.u₄ ∈ ({1, -1} : Finset (𝓞 K))`. -/
lemma by_kummer : ↑S.u₄ ∈ ({1, -1} : Finset (𝓞 K)) := by
  have h0 := lambda_sq_div_lambda_fourth
  have hX := lambda_sq_div_new_X_cubed S
  suffices hh : S.u₄ = 1 ∨ S.u₄ = -1 by
    rcases hh with (h | h) <;> simp [h]
  apply eq_one_or_neg_one_of_unit_of_congruent hζ
  rcases hX with ⟨kX, hkX⟩
  rcases lambda_pow_four_dvd_cube_sub_one_or_add_one_of_lambda_not_dvd hζ S.lambda_not_dvd_Y with
    (HY | HY) <;> rcases lambda_pow_four_dvd_cube_sub_one_or_add_one_of_lambda_not_dvd
      hζ S.lambda_not_dvd_Z with (HZ | HZ) <;> replace HY := h0.trans HY <;> replace HZ :=
      h0.trans HZ <;> rcases HY with ⟨kY, hkY⟩ <;> rcases HZ with ⟨kZ, hkZ⟩
  · use -1
    use kX - kY - S.u₄ * kZ
    rw [show λ ^ 2 * (kX - kY - ↑(u₄ S) * kZ) = λ ^ 2 * kX - λ ^ 2 * kY - ↑(u₄ S) * (λ ^ 2 * kZ) by ring]
    rw [← hkX, ← hkY, ← hkZ, ← S.formula2]
    ring
  · use 1
    use - kX + kY + S.u₄ * kZ
    rw [show λ ^ 2 * (-kX + kY + ↑(u₄ S) * kZ) = - (λ ^ 2 * kX - λ ^ 2 * kY - ↑(u₄ S) * (λ ^ 2 * kZ)) by ring]
    rw [← hkX, ← hkY, ← hkZ, ← S.formula2]
    ring
  · use 1
    use kX - kY - S.u₄ * kZ
    rw [show λ ^ 2 * (kX - kY - ↑(u₄ S) * kZ) = λ ^ 2 * kX - λ ^ 2 * kY - ↑(u₄ S) * (λ ^ 2 * kZ) by ring]
    rw [← hkX, ← hkY, ← hkZ, ← S.formula2]
    ring
  · use -1
    use - kX + kY + S.u₄ * kZ
    rw [show λ ^ 2 * (-kX + kY + ↑(u₄ S) * kZ) = - (λ ^ 2 * kX - λ ^ 2 * kY - ↑(u₄ S) * (λ ^ 2 * kZ)) by ring]
    rw [← hkX, ← hkY, ← hkZ, ← S.formula2]
    ring

/-- Given `S : Solution`, we have that
`S.Y ^ 3 + (S.u₄ * S.Z) ^ 3 = S.u₅ * (λ ^ (S.multiplicity - 1) * S.X) ^ 3`. -/
lemma final : S.Y ^ 3 + (S.u₄ * S.Z) ^ 3 = S.u₅ * (λ ^ (S.multiplicity - 1) * S.X) ^ 3 := by
  rw [show S.Y ^ 3 + (S.u₄ * S.Z) ^ 3 = S.Y ^ 3 + S.u₄^2 * S.u₄ * S.Z ^ 3 by ring]
  have f2 := formula2 S
  rw [show Y S ^ 3 + ↑(u₄ S) * Z S ^ 3 = Y S ^ 3 + 1 * ↑(u₄ S) * Z S ^ 3 by ring] at f2
  have simple_kummer := by_kummer S
  simp only [Finset.mem_insert, Finset.mem_singleton] at simple_kummer
  have hh : S.u₄ ^ 2 = (1 : 𝓞 K) := by
    rcases simple_kummer with (h | h) <;> simp only [h, one_pow, even_two, Even.neg_pow, one_pow]
  nth_rewrite 1 [← hh] at f2
  exact f2

/-- Given `S : Solution`, we can construct a `Solution'_final : Solution'`. -/
noncomputable
def _root_.Solution'_final : Solution' where
  a := S.Y
  b := S.u₄ * S.Z
  c := λ ^ (S.multiplicity - 1) * S.X
  u := S.u₅
  ha := S.lambda_not_dvd_Y
  hb := fun h ↦ S.lambda_not_dvd_Z <| Units.dvd_mul_left.1 h
  hc := fun h ↦ S.X_ne_zero <| by simpa [lambda_ne_zero] using h
  coprime := (isCoprime_mul_unit_left_right S.u₄.isUnit _ _).2 S.coprime_Y_Z
  hcdvd := by
    refine dvd_mul_of_dvd_left (dvd_pow_self _ (fun h ↦ ?_)) _
    rw [Nat.sub_eq_iff_eq_add (le_trans (by norm_num) S.two_le_multiplicity), zero_add] at h
    simpa [h] using S.two_le_multiplicity
  H := final S

/-- Given `S : Solution`, we have that `(Solution'_final S).multiplicity = S.multiplicity - 1`. -/
lemma _root_.Solution'_final_multiplicity :
    (Solution'_final S).multiplicity = S.multiplicity - 1 := by
  refine (multiplicity.unique' (by simp [Solution'_final]) (fun h ↦ S.lambda_not_dvd_X ?_)).symm
  obtain ⟨k, hk : λ ^ (S.multiplicity - 1) * S.X = λ ^ (S.multiplicity - 1 + 1) * k⟩ := h
  rw [pow_succ, mul_assoc] at hk
  simp only [mul_eq_mul_left_iff, pow_eq_zero_iff', lambda_ne_zero, ne_eq, false_and,
    or_false] at hk
  simp [hk]

/-- Given `S : Solution`, we have that `(Solution'_final S).multiplicity < S.multiplicity`. -/
lemma _root_.Solution'_final_multiplicity_lt :
    (Solution'_final S).multiplicity < S.multiplicity := by
  rw [Solution'_final_multiplicity S, Nat.sub_one]
  exact Nat.pred_lt <| by linarith [S.two_le_multiplicity]

/-- Given `S : Solution`,
there exists a `S₁ : Solution` such that `S₁.multiplicity < S.multiplicity`. -/
theorem exists_Solution_multiplicity_lt :
    ∃ (S₁ : Solution), S₁.multiplicity < S.multiplicity := by
  obtain ⟨S₁, hS₁⟩ := exists_Solution_of_Solution' (Solution'_final S)
  exact ⟨S₁, hS₁ ▸ Solution'_final_multiplicity_lt S⟩

end Solution

/-- For all `a`, `b`, `c` in `𝓞 K`, for all `u` in `(𝓞 K)ˣ`, if `c ≠ 0` and `¬ λ ∣ a` and
`¬ λ ∣ b` and `λ ∣ c` and `gcd(a,b) = 1`, then `a ^ 3 + b ^ 3 ≠ u * c ^ 3`. -/
theorem fermatLastTheoremForThreeGen : FermatLastTheoremForThreeGen := by
  intro a b c u hc ha hb hcdvd coprime H
  let S' : Solution' :=
  { a := a
    b := b
    c := c
    u := u
    ha := ha
    hb := hb
    hc := hc
    coprime := coprime
    hcdvd := hcdvd
    H := H }
  obtain ⟨S, -⟩ := exists_Solution_of_Solution' S'
  obtain ⟨Smin, hSmin⟩ := S.exists_minimal
  obtain ⟨Sfin, hSfin⟩ := Smin.exists_Solution_multiplicity_lt
  linarith [hSmin Sfin]

end FermatLastTheoremForThreeGen

end eisenstein

end case2

/-- For all `a`, `b`, `c` in `ℕ`, if `a ≠ 0` and `b ≠ 0` and `c ≠ 0`,
then `a ^ 3 + b ^ 3 ≠ c ^ 3`. -/
theorem fermatLastTheoremThree : FermatLastTheoremFor 3 := by
  apply FermatLastTheoremForThree_of_FermatLastTheoremThreeGen
  exact fermatLastTheoremForThreeGen

--#print axioms fermatLastTheoremThree
