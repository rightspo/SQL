SELECT menu.pizza_name, menu.price, pizzeria.name
FROM menu
JOIN pizzeria ON menu.pizzeria_id = pizzeria.id
WHERE menu.id NOT IN (SELECT person_order.menu_id
					  FROM person_order)
ORDER BY 1, 2