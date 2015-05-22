note
	description: "Affichage de la partie jou�e dans une fen�tre"
	author: "Sarah Laflamme"
	date: "$Date$"

class
	AFFICHAGE_PARTIE

inherit
	AFFICHAGE

create
	make

feature {NONE} -- Initialisation

	make(a_partie_en_cours: PARTIE)
			-- Constructeur de `Current'.
		local

		do
			controleur := controleurs_factory.controleur
			controleur_images := controleurs_factory.controleur_images
			controleur_audio := controleurs_factory.controleur_audio
			controleur_texte := controleurs_factory.controleur_texte

			controleur.screen_surface.fill_rect (create {GAME_COLOR}.make_rgb(43, 24, 24), 0, 0, controleur.screen_surface.width, controleur.screen_surface.height)

			set_partie(a_partie_en_cours)
			create zone_tableau.make(partie.tableau)
			create zone_score.make
			create zone_temps.make

			controleur.flip_screen

			-- M�thodes d'�v�nements
			controleur.clear_event_controller
			controleur.event_controller.on_mouse_motion_position.extend(agent on_mouse_move)
			controleur.event_controller.on_mouse_button_down.extend (agent on_mouse_down)
			controleur.event_controller.on_iteration.extend (agent on_iteration)
			controleur.event_controller.on_quit_signal.extend (agent on_quit)

			sons_factory.jouer_musique (sons_factory.musique_partie)

		end




feature -- Attributs

	partie: PARTIE
		-- Partie utilis�e dans l'affichage

	zone_tableau: ZONE_TABLEAU
		-- Zone repr�sentant l'affichage du tableau de jeu

	zone_score: ZONE_SCORE
		-- Zone repr�sentant l'affichage du score de la partie

	zone_temps: ZONE_TEMPS
		-- Zone repr�sentant l'affichage du temps restant � la partie




feature -- Setters

	set_partie(a_partie: PARTIE)
		-- Assigne la partie � afficher
		do
			partie := a_partie
		end


feature -- �v�nements

	on_mouse_move(x,y:NATURAL_16)
			-- M�thode appel�e lorsque la souris bouge dans la fen�tre
		local

		do
			-- V�rifie si la souris se trouve � l'int�rieur de la zone du tableau
			if (x > zone_tableau.depart_x) and (x < zone_tableau.depart_y + zone_tableau.dimension_fond_tableau)and
				(y > zone_tableau.depart_y) and (y < zone_tableau.depart_y + zone_tableau.dimension_fond_tableau) then

				verifier_bloc_selectionne(x, y)

			end

			-- �ventuellement, ajouter un elseif pour v�rifier le bouton 'Quitter'

		end

	on_mouse_down(is_left_button, is_right_button, is_middle_button: BOOLEAN; x, y: NATURAL_16)
			-- M�thode appel�e lorsqu'un des boutons de la souris est appuy�
		do
			if is_left_button then

				if (x > partie.selection.coin_haut_gauche.image_depart_x) and (x < partie.selection.coin_haut_gauche.image_depart_x + partie.selection.image.width) and
				(y > partie.selection.coin_haut_gauche.image_depart_y) and (y < partie.selection.coin_haut_gauche.image_depart_y + partie.selection.image.height) then


					partie.tableau.tourner_blocs(partie.selection.coin_haut_gauche)
					partie.tableau.verifier_combos

				end

			end

		end


	on_iteration
			-- M�thode lanc�e � chaque it�ration du jeu
		do
			zone_tableau.dessiner(partie.tableau)
			zone_temps.dessiner
			controleur.screen_surface.draw_surface (partie.selection.image, partie.selection.coin_haut_gauche.image_depart_x - 5, partie.selection.coin_haut_gauche.image_depart_y - 5)
			controleur.flip_screen
		end

	on_quit
			-- M�thode lanc�e lorsque la fen�tre est ferm�e
		do
			controleur.stop
		end


feature -- M�thodes

	verifier_bloc_selectionne(a_x, a_y: INTEGER)
		-- V�rifie la souris se trouve sur quel bloc et l'assigne � la s�lection
		local
			i: INTEGER -- Compteur de chaque ligne
			j: INTEGER -- Compter de chaque bloc d'une ligne
			position: INTEGER
			l_liste_blocs: LIST[LIST[BLOC]]
		do
			l_liste_blocs := partie.tableau.liste_blocs

				from
				i := 1
				until
					i >= l_liste_blocs.count
				loop

					-- V�rifie tous les blocs de la ligne en cours et assigne le bloc � la s�lection si besoin
					from
						j := 1
					until
						j >= l_liste_blocs.at(i).count
					loop

						if (a_x > l_liste_blocs.at(i).at(j).image_depart_x) and (a_x < l_liste_blocs.at(i).at(j).image_depart_x + l_liste_blocs.at(i).at(j).image.width)and
						(a_y > l_liste_blocs.at(i).at(j).image_depart_y) and (a_y < l_liste_blocs.at(i).at(j).image_depart_y + l_liste_blocs.at(i).at(j).image.height) then

							if i = l_liste_blocs.at(i).count then
								position := j - 1
							else
								position := j
							end

							partie.selection.coin_haut_gauche := l_liste_blocs.at(i).at(position)

						end

						j := j+1
					end

					i := i+1

			end

		end

end
