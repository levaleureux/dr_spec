# Fixture d'equivalence semantique pour l'instrumenteur de couverture (#113).
# Chaque methode est une EXPRESSION coupee sur plusieurs lignes par une forme de
# continuation differente. Le code instrumente doit renvoyer EXACTEMENT la meme
# valeur que l'original : aucun __dr_cov ne doit s'inserer au milieu de
# l'expression et en detourner la valeur de retour.
#
# Les valeurs attendues sont volontairement choisies pour qu'une coupure
# (court-circuit perdu, ternaire casse, chaine rompue) change le resultat.
module ContinuationsFixture
  # && termine en fin de ligne (court-circuit sur le 1er operande).
  def self.and_op
    false &&
      true &&
      true
  end

  # || termine en fin de ligne (court-circuit sur le 1er operande).
  def self.or_op
    true ||
      false ||
      false
  end

  # + arithmetique termine en fin de ligne.
  def self.arith
    10 +
      20 +
      30
  end

  # virgules dans un litteral multi-lignes (profondeur de crochets).
  def self.comma
    [1,
     2,
     3].reduce(0) { |a, b| a + b }
  end

  # chaine de methodes a POINT EN TETE (l'operateur ouvre la ligne suivante).
  def self.chain
    [1, 2, 3]
      .map { |x| x * 2 }
      .reduce(0) { |a, b| a + b }
  end

  # navigation sure a point en tete (&.).
  def self.safe_chain
    obj = [1, 2, 3]
    obj
      &.map { |x| x + 1 }
      &.reduce(0) { |a, b| a + b }
  end

  # ternaire coupe sur trois lignes (cond ? / valeur :).
  def self.ternary
    (1 < 2) ?
      100 :
      200
  end

  # mot-cle `and` en fin de ligne (court-circuit sur le 1er operande).
  def self.kw_and
    false and
      true and
      true
  end

  # mot-cle `or` en fin de ligne (court-circuit sur le 1er operande).
  def self.kw_or
    true or
      false or
      false
  end

  # continuation explicite par antislash.
  def self.backslash
    1 + \
      2 + \
      3
  end
end
