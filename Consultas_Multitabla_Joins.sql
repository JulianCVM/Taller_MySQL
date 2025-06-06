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
