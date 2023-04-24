USE `gutu`;

INSERT INTO `items` (`id`, `name`, `label`, `limit`, `rare`, `can_remove`) VALUES (420, 'chicha', 'Chicha', 25, 0, 1);
INSERT INTO `items` (`id`, `name`, `label`, `limit`, `rare`, `can_remove`) VALUES (421, 'them', 'Thé a la menthe', 25, 0, 1);

SET @job_name = 'weed';
SET @society_name = 'society_weed';
SET @job_Name_Caps = 'White Widow';

INSERT INTO `addon_account` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1),
  ('society_weed_fridge', 'White Widow (frigo)', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `jobs` (name, label, whitelisted, rob) VALUES
  (@job_name, @job_Name_Caps, 1, 0)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (@job_name, 0, 'empl', 'Employé', 250, '{}', '{}'),
  (@job_name, 1, 'chef', 'Chef ', 250, '{}', '{}'),
  (@job_name, 2, 'resp', 'Responsable', 300, '{}', '{}'),
  (@job_name, 3, 'boss', 'Gérant', 300, '{}', '{}')
;

