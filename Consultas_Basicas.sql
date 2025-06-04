-- 1
-- Consulta todos los datos de la tabla `usuarios` para ver la lista completa de clientes.

SELECT * 
FROM usuarios;



-- 2
-- Muestra los nombres y correos electrónicos de todos los clientes que residen en la ciudad de Madrid.

-- Esta consulta de aca, filtra a los usuarios por 'tipo_id' validando que sean Clientes y no Empleados
SELECT u.nombre, u.email 
FROM usuarios AS u 
INNER JOIN tipos_usuarios AS tu 
ON u.tipo_id = tu.tipo_id 
WHERE u.ciudad = 'Madrid'
AND tu.nombre = 'Cliente'; 

SELECT nombre, email
FROM usuarios
WHERE ciudad = 'madrid' AND tipo_id = '1';                    -- Como tal, los usuarios que son clientes son de 'tipo_id = 1', por lo cual, se pone esta condicion


-- SELECT * FROM tipos_usuarios;
-- SELECT * FROM usuarios;


-- 3
-- SELECT * FROM productos;
-- Obtén una lista de productos con un precio mayor a $100.000, mostrando solo el nombre y el precio.

SELECT nombre, precio 
FROM productos 
WHERE precio > 100000;




-- 4
-- SELECT * 
-- FROM empleados;
-- Encuentra todos los empleados que tienen un salario superior a $2.500.000, mostrando su nombre, puesto y salario.

SELECT nombre, puesto, salario 
FROM empleados AS e INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
WHERE salario>2500000;




-- 5
-- SELECT * 
-- FROM productos;
-- Lista los nombres de los productos en la categoría "Electrónica", ordenados alfabéticamente.

SELECT nombre
FROM productos
WHERE categoria = 'Electrónica'
ORDER BY nombre ASC;




-- 6
-- SELECT *
-- FROM pedidos;
-- Muestra los detalles de los pedidos que están en estado "Pendiente", incluyendo el ID del pedido, el ID del cliente y la fecha del pedido.

SELECT pedido_id, cliente_id, fecha_pedido 
FROM pedidos 
WHERE estado = 'Pendiente';




-- 7
-- SELECT *
-- FROM productos;
-- Encuentra el nombre y el precio del producto más caro en la base de datos.

SELECT nombre, MAX(precio) 
FROM productos;




-- 8
-- SELECT *
-- FROM pedidos;
-- Obtén el total de pedidos realizados por cada cliente, mostrando el ID del cliente y el total de pedidos.

SELECT COUNT(pedido_id), cliente_id
FROM pedidos
GROUP BY cliente_id;




-- 9
-- SELECT *
-- FROM empleados;
-- Calcula el promedio de salario de todos los empleados en la empresa.

SELECT AVG(salario)
FROM empleados;




-- 10
-- SELECT *
-- FROM productos;
-- Encuentra el número de productos en cada categoría, mostrando la categoría y el número de productos.

SELECT categoria, stock
FROM productos
GROUP BY categoria;




-- 11
-- SELECT *
-- FROM productos;
-- Obtén una lista de productos con un precio mayor a $75 USD, mostrando solo el nombre, el precio y su respectivo precio en USD.

SELECT nombre, precio, precio / 4400 AS precioUSD
FROM productos
WHERE precio / 4400 > 75;




-- 12
-- SELECT *
-- FROM proveedores;
-- Lista todos los proveedores registrados.

SELECT *
FROM proveedores
WHERE fecha_registro IS NOT NULL;
