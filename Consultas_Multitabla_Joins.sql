--  Consulta 1: Nombres de clientes y detalles de sus pedidos
-- ------------------------------------------------------------

--  Vistas previas para referencia rápida (opcional en entorno de prueba)
SELECT * FROM usuarios;
SELECT * FROM tipos_usuarios;
SELECT * FROM pedidos;
SELECT * FROM detalles_pedidos;

-- ! Crear vista con los usuarios que son clientes
CREATE VIEW view_Tipos_Usuarios_Clientes AS
SELECT us.usuario_id, us.nombre
FROM tipos_usuarios AS tu
INNER JOIN usuarios AS us ON tu.tipo_id = us.tipo_id
WHERE tu.nombre = 'cliente';

-- ! Crear vista con detalles de los pedidos
-- * Incluye: ID del pedido, cliente, fecha, estado y detalles del producto
-- * Se agrupa por pedido_id (¡Advertencia! Puede omitir detalles si hay varios por pedido)
CREATE VIEW view_Pedidos_Detalles_pedidos AS
SELECT 
    pe.pedido_id, 
    pe.cliente_id, 
    pe.fecha_pedido, 
    pe.estado, 
    dpe.detalle_id, 
    dpe.producto_id, 
    dpe.cantidad, 
    dpe.precio_unitario
FROM pedidos AS pe
INNER JOIN detalles_pedidos AS dpe ON pe.pedido_id = dpe.pedido_id
GROUP BY pe.pedido_id;

--  Consulta principal
-- * Une los nombres de clientes con los detalles de sus pedidos
SELECT vtu.nombre, vpdp.*
FROM view_Tipos_Usuarios_Clientes AS vtu
INNER JOIN view_Pedidos_Detalles_pedidos AS vpdp ON vtu.usuario_id = vpdp.cliente_id;

-- TODO: Eliminar las vistas creadas si ya no son necesarias
DROP VIEW view_Tipos_Usuarios_Clientes;
DROP VIEW view_Pedidos_Detalles_pedidos;





--  Consult 2: Productos pedidos con su precio unitario
-- ------------------------------------------------------

-- * Objetivo:
--     - Listar todos los productos que han sido incluidos en algún pedido.
--     - Mostrar el nombre del producto y el precio unitario registrado en el pedido.

-- * Tablas/Vistas involucradas:
--     - productos (pr): Contiene los nombres y datos de los productos.
--     - view_Pedidos_Detalles_pedidos (VPDP): Vista que incluye detalles de los pedidos, como producto_id y precio_unitario.

SELECT pr.nombre, VPDP.precio_unitario
FROM productos AS pr
INNER JOIN view_Pedidos_Detalles_pedidos AS VPDP 
    ON pr.producto_id = VPDP.producto_id;










--  Consulta 3: Nombres de clientes y empleados que gestionaron sus pedidos
-- ------------------------------------------------------------------------

-- * Objetivo:
--     - Mostrar los nombres de los clientes junto con los nombres de los empleados que gestionaron sus pedidos.
--     - Utiliza vistas intermedias para organizar y simplificar las relaciones entre tablas.

-- ! Vista: Usuarios que son empleados
CREATE VIEW view_tipos_usuarios_empleados AS
SELECT us.usuario_id, us.nombre
FROM tipos_usuarios AS tu
INNER JOIN usuarios AS us 
    ON tu.tipo_id = us.tipo_id
WHERE tu.nombre = 'empleado';

-- ! Vista: Información detallada de empleados
-- * Une los usuarios que son empleados con la tabla empleados para obtener todos los datos relevantes.
CREATE VIEW view_empleados_data AS
SELECT VTUE.usuario_id, VTUE.nombre, emp.empleado_id, emp.puesto, emp.fecha_contratacion, emp.salario 
FROM view_tipos_usuarios_empleados AS VTUE
INNER JOIN empleados AS emp
    ON emp.usuario_id = VTUE.usuario_id;

-- ! Vista: Relación de empleados con pedidos gestionados
-- * Requiere que la tabla 'pedidos' tenga una columna 'empleado_id' que indique quién gestionó el pedido.
DROP VIEW IF EXISTS view_empleado_pedido;
CREATE VIEW view_empleado_pedido AS
SELECT VED.*, ped.pedido_id, ped.cliente_id, ped.fecha_pedido, ped.estado
FROM view_empleados_data AS VED
INNER JOIN pedidos AS ped 
    ON VED.empleado_id = ped.empleado_id;

-- ! Vista: Relación de clientes con pedidos realizados
DROP VIEW IF EXISTS view_cliente_pedido;
CREATE VIEW view_cliente_pedido AS
SELECT ped.cliente_id, VTUC.nombre, ped.pedido_id, ped.fecha_pedido, ped.estado
FROM view_tipos_usuarios_clientes AS VTUC
INNER JOIN pedidos AS ped 
    ON VTUC.usuario_id = ped.cliente_id;

--  Consultas de verificación (útiles en desarrollo)
SELECT * FROM pedidos;
SELECT * FROM empleados;
SELECT * FROM usuarios;

--   Resultado final: Nombres de clientes con los nombres de empleados que gestionaron sus pedidos
-- * Se cruzan las vistas cliente-pedido y empleado-pedido a través del ID del pedido.
SELECT VCP.nombre AS nombre_cliente, VEP.nombre AS nombre_empleado
FROM view_cliente_pedido AS VCP
INNER JOIN view_empleado_pedido AS VEP 
    ON VCP.pedido_id = VEP.pedido_id
ORDER BY VCP.nombre ASC;




-- ! Consulta 4: Pedidos con detalles y productos
-- * Muestra todos los pedidos junto con los productos asociados en cada uno (si los hay)
-- * Incluye también los pedidos que no tienen productos aún, usando LEFT JOIN

-- ? Tablas de referencia
SELECT * FROM pedidos;
SELECT * FROM detalles_pedidos;
SELECT * FROM productos;

-- ? Consulta completa con columnas explícitas para mayor claridad y evitar duplicados
SELECT 
  pe.pedido_id,                -- ID del pedido
  pe.cliente_id,               -- ID del cliente
  pe.empleado_id,              -- ID del empleado
  pe.fecha_pedido,             -- Fecha en que se realizó el pedido
  pe.estado,                   -- Estado actual del pedido
  dp.detalle_id,               -- ID del detalle del pedido
  dp.cantidad,                 -- Cantidad de unidades pedidas
  dp.precio_unitario,          -- Precio por unidad en el detalle
  pr.producto_id,              -- ID del producto
  pr.nombre AS producto_nombre, -- Nombre del producto
  pr.categoria,                -- Categoría del producto
  pr.precio AS producto_precio -- Precio registrado del producto
FROM pedidos AS pe
LEFT JOIN detalles_pedidos AS dp ON pe.pedido_id = dp.pedido_id
LEFT JOIN productos AS pr ON dp.producto_id = pr.producto_id;





-- ! Consulta 5: Productos y detalles de pedidos asociados (uso de RIGHT JOIN)
-- * Muestra todos los pedidos, junto con los detalles y los productos involucrados
-- * Utiliza RIGHT JOIN para asegurar que se incluyan todos los registros de pedidos,
-- * incluso si no tienen productos relacionados directamente
-- ? Si un producto no está en un pedido, no aparecerá, ya que RIGHT JOIN prioriza la tabla derecha
-- TODO: Considerar usar LEFT JOIN desde `productos` si se desea ver productos sin pedidos

SELECT *
FROM productos AS pr
RIGHT JOIN detalles_pedidos AS dp ON pr.producto_id = dp.producto_id
RIGHT JOIN pedidos AS pe ON dp.pedido_id = pe.pedido_id;




-- ! Consulta 6: Empleados y sus pedidos (LEFT JOIN)
-- * Lista todos los empleados junto con los pedidos que han gestionado
-- * Incluye también los empleados que no tienen pedidos asociados
-- ? Útil para ver qué empleados aún no han gestionado pedidos

SELECT 
  emp.empleado_id,
  emp.usuario_id,
  emp.puesto,
  emp.fecha_contratacion,
  emp.salario,
  pe.pedido_id,
  pe.cliente_id,
  pe.fecha_pedido,
  pe.estado
FROM empleados AS emp
LEFT JOIN pedidos AS pe ON emp.empleado_id = pe.empleado_id;




-- ! Consulta 7: Empleados sin pedidos gestionados
-- * Encuentra los empleados que no han gestionado ningún pedido
-- * Utiliza `LEFT JOIN` para incluir todos los empleados
-- * La condición `WHERE pedido_id IS NULL` asegura que se filtren solo los que no tienen pedidos asociados


-- ! Consulta mostrando toda la data completa
-- SELECT *
-- FROM empleados AS emp
-- LEFT JOIN pedidos AS pe
-- ON emp.empleado_id = pe.empleado_id
-- WHERE pedido_id IS NULL;
SELECT 
  emp.empleado_id,
  emp.usuario_id,
  emp.puesto,
  emp.fecha_contratacion,
  emp.salario
FROM empleados AS emp
LEFT JOIN pedidos AS pe ON emp.empleado_id = pe.empleado_id
WHERE pe.pedido_id IS NULL;



-- ! Consulta 8: Total gastado por pedido
-- * Calcula el valor total de cada pedido multiplicando la cantidad por el precio unitario de cada producto
-- * Utiliza un `JOIN` entre pedidos y detalles_pedidos para combinar la información
-- * Muestra el ID del pedido y el valor total correspondiente a cada detalle (producto) del pedido

SELECT pe.pedido_id, (pd.cantidad * pd.precio_unitario) AS valorPedido
FROM pedidos AS pe
JOIN detalles_pedidos AS pd 
ON pe.pedido_id = pd.pedido_id;




-- ! Consulta 9
: Combinación total de clientes y productos
-- * Realiza un `CROSS JOIN` para obtener todas las combinaciones posibles entre clientes y productos
-- * Muestra todas las filas donde cada cliente se combina con cada producto
-- * Nota: En `CROSS JOIN` no se debe usar condición ON, ya que une todas las filas de ambas tablas sin filtrar

SELECT *
FROM view_tipos_usuarios_clientes AS VTUC
CROSS JOIN productos AS pr
ON VTUC.usuario_id = pr.producto_id;



-- ! Consulta 10: Clientes y productos comprados (si existen)
-- * Obtiene los nombres de los clientes y los nombres de los productos que han comprado
-- * Usa `LEFT JOIN` para incluir también los clientes que no han realizado ningún pedido
-- * La primera unión relaciona clientes con sus pedidos y detalles
-- * La segunda unión asocia los detalles de pedidos con los productos correspondientes


SELECT VTUC.nombre, pr.nombre
FROM view_tipos_usuarios_clientes AS VTUC
LEFT JOIN view_pedidos_detalles_pedidos AS VPDP
ON VTUC.usuario_id = VPDP.cliente_id
LEFT JOIN productos AS pr
ON pr.producto_id = VPDP.producto_id;


-- ! Consulta 11: Proveedores por producto específico
-- * Lista todos los proveedores que suministran un producto determinado
-- * Se une la tabla de proveedores con la tabla intermedia de productos-proveedores
-- * Luego se une con la tabla de productos para filtrar por el nombre del producto
-- * Cambia el valor en la cláusula WHERE para buscar por otro producto específico

SELECT prov.*, pr.*
FROM proveedores AS prov
JOIN proveedores_productos AS provPr
  ON prov.proveedor_id = provPr.proveedor_id
JOIN productos AS pr
  ON pr.producto_id = provPr.producto_id
WHERE pr.nombre = 'Televisor';  -- <- Cambia aquí el nombre del producto deseado


SELECT productos.nombre
FROM productos;

-- Laptop
-- Smartphone
-- Televisor
-- Auriculares
-- Teclado
-- Ratón
-- Impresora
-- Escritorio
-- Silla
-- Tableta
-- Lámpara
-- Ventilador
-- Microondas
-- Licuadora
-- Refrigerador
-- Cafetera
-- Altavoces
-- Monitor
-- Bicicleta
-- Reloj Inteligente
-- Auricular Bluetooth Pro




-- ! Consulta 12: Productos por proveedor específico
-- * Obtiene todos los productos que ofrece un proveedor en particular
-- * Se realiza un JOIN entre productos, la tabla intermedia y proveedores
-- * Se filtra por el nombre del proveedor deseado
-- * Cambia el valor en la cláusula WHERE según el proveedor que desees consultar

SELECT pr.*
FROM productos AS pr
JOIN proveedores_productos AS prpr
  ON pr.producto_id = prpr.producto_id
JOIN proveedores AS prov
  ON prov.proveedor_id = prpr.proveedor_id
WHERE prov.nombre = 'Accesorios y Más S.A.S.';  -- <- Cambia aquí el nombre del proveedor

-- ? Lista de proveedores disponibles:
-- Tech Supplies S.A.
-- Global Components Ltda.
-- Electrodomésticos del Norte
-- Accesorios y Más S.A.S.
-- Muebles & Diseño S.A.
-- Proveedor XYZ S.A.S.



-- Lista los proveedores que no están asociados a ningún producto (es decir, que aún no suministran).
-- ! Consulta: Proveedores sin productos asociados
-- * Lista todos los proveedores que aún no están vinculados a ningún producto
-- * Se usa `LEFT JOIN` para incluir todos los proveedores, incluso los que no tienen coincidencias
-- * Se filtran aquellos cuyo producto asociado es NULL, lo que indica que no están suministrando nada

SELECT prov.*
FROM proveedores AS prov
LEFT JOIN proveedores_productos AS provPr
  ON prov.proveedor_id = provPr.proveedor_id
WHERE provPr.producto_id IS NULL;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         