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
