----------------------------------------------------------------------------------------



-- ! Consulta principal
-- * Selecciona todos los datos de la tabla `usuarios`
-- ? Se usa para ver la lista completa de clientes registrados
SELECT * 
FROM usuarios;



----------------------------------------------------------------------------------------



-- ! Consulta 2: Clientes en Madrid
-- * Muestra los nombres y correos electrónicos de todos los clientes que residen en la ciudad de Madrid
-- * Esta consulta filtra a los usuarios por 'tipo_id', validando que sean Clientes y no Empleados
SELECT u.nombre, u.email 
FROM usuarios AS u 
INNER JOIN tipos_usuarios AS tu 
  ON u.tipo_id = tu.tipo_id 
WHERE u.ciudad = 'Madrid'
  AND tu.nombre = 'Cliente'; 


-- ? Consulta secundaria para comprobación rápida
-- * Verifica si los clientes (tipo_id = 1) que viven en Madrid están siendo filtrados correctamente
-- SELECT nombre, email
-- FROM usuarios
-- WHERE ciudad = 'madrid' AND tipo_id = '1';


-- TODO: Consultas auxiliares para revisar el contenido de las tablas base
-- SELECT * FROM tipos_usuarios;
-- SELECT * FROM usuarios;



----------------------------------------------------------------------------------------



-- ! Consulta 3: Productos con precio alto
-- * Obtiene una lista de productos cuyo precio es mayor a $100.000
-- * Solo muestra el nombre y el precio de cada producto
SELECT nombre, precio 
FROM productos 
WHERE precio > 100000
-- ? ORDER BY precio ASC   -- En caso de que se quiera ver en orden ascendente
;

-- TODO: Consultar todos los productos si es necesario para verificar datos base
-- SELECT * FROM productos;



----------------------------------------------------------------------------------------



-- ! Consulta 4: Empleados con salario alto
-- * Encuentra todos los empleados que tienen un salario superior a $2.500.000
-- * Muestra el nombre, puesto y salario
SELECT nombre, puesto, salario 
FROM empleados AS e
INNER JOIN usuarios AS u ON u.usuario_id = e.usuario_id
WHERE salario > 2500000;

-- TODO: Consultar todos los empleados si se requiere revisar los datos completos
-- SELECT * FROM empleados;



----------------------------------------------------------------------------------------



-- ! Consulta 5: Productos de categoría "Electrónica"
-- * Lista los nombres de los productos que pertenecen a la categoría "Electrónica"
-- * Ordenados alfabéticamente por nombre
SELECT nombre
FROM productos
WHERE categoria = 'Electrónica'
ORDER BY nombre ASC;

-- TODO: Verificar si existen productos con categorías similares o mal escritas
-- SELECT * FROM productos;



----------------------------------------------------------------------------------------



-- ! Consulta 6: Pedidos en estado "Pendiente"
-- * Muestra los detalles de los pedidos que están actualmente en estado "Pendiente"
-- * Incluye el ID del pedido, el ID del cliente y la fecha del pedido
SELECT pedido_id, cliente_id, fecha_pedido 
FROM pedidos 
WHERE estado = 'Pendiente';

-- TODO: Consultar todos los pedidos si es necesario para validaciones generales
-- SELECT * FROM pedidos;



----------------------------------------------------------------------------------------



-- ! Consulta 7: Producto más caro
-- * Encuentra el nombre y el precio del producto más caro registrado en la base de datos
-- ? Usa la función MAX para identificar el mayor valor en la columna 'precio'
SELECT nombre, MAX(precio) 
FROM productos;

-- TODO: Consultar todos los productos si se quiere validar el resultado manualmente
-- SELECT * FROM productos;



----------------------------------------------------------------------------------------



-- ! Consulta 8: Total de pedidos por cliente
-- * Obtiene la cantidad total de pedidos realizados por cada cliente
-- * Muestra el ID del cliente junto con el número total de pedidos
SELECT COUNT(pedido_id), cliente_id
FROM pedidos
GROUP BY cliente_id;

-- TODO: Consultar todos los pedidos si se requiere validar los conteos
-- SELECT * FROM pedidos;



----------------------------------------------------------------------------------------



-- ! Consulta 9: Promedio de salario de empleados
-- * Calcula el salario promedio de todos los empleados en la empresa
SELECT AVG(salario)
FROM empleados;

-- TODO: Consultar todos los empleados para posibles revisiones de salario
-- SELECT * FROM empleados;



----------------------------------------------------------------------------------------



-- ! Consulta 10: Conteo de productos por categoría
-- * Encuentra el número de productos en cada categoría
-- * Muestra la categoría y el total de productos en ella
SELECT categoria, COUNT(*) AS total_productos
FROM productos
GROUP BY categoria;



----------------------------------------------------------------------------------------



-- ! Consulta 11: Productos con precio mayor a $75 USD
-- * Obtiene nombre, precio en COP y precio convertido a USD
-- * Filtra productos cuyo precio en USD sea mayor a 75 dólares
SELECT nombre, precio, precio / 4400 AS precioUSD
FROM productos
WHERE precio / 4400 > 75;



----------------------------------------------------------------------------------------



-- ! Consulta 12: Proveedores registrados
-- * Lista todos los proveedores que tienen fecha de registro (no nulos)
SELECT *
FROM proveedores
WHERE fecha_registro IS NOT NULL;

-- TODO: Revisar proveedores sin fecha de registro si es necesario
-- SELECT *
-- FROM proveedores
-- WHERE fecha_registro IS NULL;



----------------------------------------------------------------------------------------