note
	description: "Tableau de 8x8 blocs dans lequel se d�roule la partie"
	author: "Sarah Laflamme"
	date: "$Date$"

class
	TABLEAU

inherit
	REGLES_PARTIE_SHARED

create
	make

feature {NONE} -- Initialisation

	make
			-- Constructeur de `Current'.
		local
			i:INTEGER -- Compteur pour chaque ligne
			j:INTEGER -- Compteur pour chaque bloc de la ligne
			ligne: LIST[BLOC]
			nouveau_bloc: BLOC
		do
			create {ARRAYED_LIST[ARRAYED_LIST[BLOC]]} liste_blocs.make(regles_partie.taille_tableau)

			from
				i := 1
			until
				i > regles_partie.taille_tableau
			loop
				-- cr�ation de la ligne
				create {ARRAYED_LIST[BLOC]} ligne.make(regles_partie.taille_tableau)

				-- ajout des blocs dans la ligne
				from
					j := 1
				until
					j > regles_partie.taille_tableau
				loop
					create nouveau_bloc.make_hasard(j, i)
					ligne.extend(nouveau_bloc)
					j := j+1
				end

				-- ajout de la ligne dans le tableau
				liste_blocs.extend (ligne)
				i := i+1

			end


		end

feature -- Attributs

	liste_blocs:LIST[LIST[BLOC]] assign set_liste_blocs
			-- Liste des blocs qui se trouvent pr�sentement dans le tableau.
			-- Chaque liste correspond � une ligne du tableau

feature -- Setters

	set_liste_blocs(a_liste_blocs: LIST[LIST[BLOC]])
		-- Assigne la liste des blocs du tableau
		do
			liste_blocs := a_liste_blocs
		end

feature -- Methodes

	tourner_blocs(a_bloc_selection: BLOC)
		-- �change les positions des 4 blocs dans la s�lection dans le sens horaire)
		local
			l_bloc_1, l_bloc_2, l_bloc_3, l_bloc_4 : BLOC
			x_depart: INTEGER
			y_depart: INTEGER
		do
			x_depart := a_bloc_selection.x
			y_depart := a_bloc_selection.y

			-- Cr�ation des blocs temporaires pour stocker les informations
			create l_bloc_1.make_hasard (1, 1)
			l_bloc_1.set_couleur (liste_blocs.at(y_depart).at(x_depart).couleur)
			l_bloc_1.set_type (liste_blocs.at(y_depart).at(x_depart).type)

			create l_bloc_2.make_hasard (1, 1)
			l_bloc_2.set_couleur (liste_blocs.at(y_depart).at(x_depart + 1).couleur)
			l_bloc_2.set_type (liste_blocs.at(y_depart).at(x_depart + 1).type)

			create l_bloc_3.make_hasard (1, 1)
			l_bloc_3.set_couleur (liste_blocs.at(y_depart + 1).at(x_depart + 1).couleur)
			l_bloc_3.set_type (liste_blocs.at(y_depart + 1).at(x_depart + 1).type)

			create l_bloc_4.make_hasard (1, 1)
			l_bloc_4.set_couleur (liste_blocs.at(y_depart + 1).at(x_depart).couleur)
			l_bloc_4.set_type (liste_blocs.at(y_depart + 1).at(x_depart).type)


			-- �change
			liste_blocs.at(y_depart).at(x_depart).set_couleur (l_bloc_4.couleur)
			liste_blocs.at(y_depart).at(x_depart).set_type (l_bloc_4.type)
			liste_blocs.at(y_depart).at(x_depart).selectionner_image

			liste_blocs.at(y_depart).at(x_depart + 1).couleur := l_bloc_1.couleur
			liste_blocs.at(y_depart).at(x_depart + 1).type := l_bloc_1.type
			liste_blocs.at(y_depart).at(x_depart + 1).selectionner_image

			liste_blocs.at(y_depart + 1).at(x_depart + 1).couleur := l_bloc_2.couleur
			liste_blocs.at(y_depart + 1).at(x_depart + 1).type := l_bloc_2.type
			liste_blocs.at(y_depart + 1).at(x_depart + 1).selectionner_image

			liste_blocs.at(y_depart + 1).at(x_depart).couleur := l_bloc_3.couleur
			liste_blocs.at(y_depart + 1).at(x_depart).type := l_bloc_3.type
			liste_blocs.at(y_depart + 1).at(x_depart).selectionner_image

		end




	verifier_combos
		-- V�rifie si un carr� de 4 blocs de la m�me couleur a �t� form�
		local
			i: INTEGER -- Compteur de chaque ligne
			j: INTEGER -- Compter de chaque bloc d'une ligne
			position: INTEGER
			l_liste_blocs: LIST[LIST[BLOC]]
			l_blocs_a_detruire: LIST[BLOC]
		do
			l_liste_blocs := liste_blocs

			from
			i := 1
			until
				i >= l_liste_blocs.count
			loop

				-- V�rifie tous les blocs de la ligne en cours
				from
					j := 1
				until
					j >= l_liste_blocs.count
				loop

					if (verifier_blocs_autour(l_liste_blocs.at (i).at (j))) then
						create {ARRAYED_LIST[BLOC]} l_blocs_a_detruire.make (4)
						l_blocs_a_detruire.extend (l_liste_blocs.at (i).at (j))
						l_blocs_a_detruire.extend (l_liste_blocs.at (i+1).at (j))
						l_blocs_a_detruire.extend (l_liste_blocs.at (i).at (j+1))
						l_blocs_a_detruire.extend (l_liste_blocs.at (i+1).at (j+1))
						detruire_blocs(l_blocs_a_detruire)
					end

					j := j+1
				end

				i := i+1

			end

		end


	verifier_blocs_autour(a_bloc: BLOC) : BOOLEAN
		-- V�rifie les 3 blocs autour du bloc envoy� afin de voir s'ils sont de la m�me couleur
		local
			l_compteur: INTEGER
			l_bloc_gauche: BLOC
			l_bloc_bas: BLOC
			l_bloc_gauche_bas: BLOC
		do
			l_bloc_gauche := liste_blocs.at (a_bloc.y).at (a_bloc.x +1)
			l_bloc_bas := liste_blocs.at (a_bloc.y + 1).at (a_bloc.x)
			l_bloc_gauche_bas := liste_blocs.at (a_bloc.y + 1).at (a_bloc.x +1)

			if attached {TYPE_ARC_EN_CIEL} l_bloc_gauche.couleur or l_bloc_gauche.couleur = a_bloc.couleur then
				l_compteur := l_compteur + 1
			end

			if attached {TYPE_ARC_EN_CIEL} l_bloc_bas.couleur or l_bloc_bas.couleur = a_bloc.couleur then
				l_compteur := l_compteur + 1
			end

			if attached {TYPE_ARC_EN_CIEL} l_bloc_gauche_bas.couleur or l_bloc_gauche_bas.couleur = a_bloc.couleur then
				l_compteur := l_compteur + 1
			end

			if l_compteur >= 3 then
				Result := true
			else
				Result := false
			end

		end


	detruire_blocs(a_blocs_a_detruire: LIST[BLOC])
		-- D�truit les blocs qui ont form� un carr�, ajoute les points correspondants et g�n�re de nouveaux blocs
		local
			nb_blocs_detruits: INTEGER
		do
			nb_blocs_detruits := a_blocs_a_detruire.count

			across
				a_blocs_a_detruire
			as
				la_blocs_a_detruire
			loop
				if attached {TYPE_DOUBLE_POINTS} liste_blocs.at (la_blocs_a_detruire.item.y).at (la_blocs_a_detruire.item.x) then

				end
				liste_blocs.at (la_blocs_a_detruire.item.y).at (la_blocs_a_detruire.item.x) := create {BLOC}.make_hasard (la_blocs_a_detruire.item.x, la_blocs_a_detruire.item.y)

			end

		end
end
