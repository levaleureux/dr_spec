# Fixture pour la non-regression #109 : litteraux multi-lignes (hash + array).
# L'instrumenteur de couverture ne doit PAS injecter __dr_cov au milieu de ces
# expressions ouvertes.
module SamplePalette
  COLORS = {
    dark:  { r: 1, g: 2, b: 3 },
    light: { r: 4, g: 5, b: 6 }
  }.freeze

  LIST = [
    1, 2,
    3, 4
  ].freeze

  # Bloc do...end.freeze : la valeur de retour ne doit PAS etre detournee
  # par l'instrumentation (cf. #111).
  SQUARES = Array.new(4) do |i|
    i * i
  end.freeze

  def self.fetch(key)
    COLORS.fetch(key)
  end

  def self.squares
    SQUARES
  end

  def self.size
    LIST.length
  end
end
