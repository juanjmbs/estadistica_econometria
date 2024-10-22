# Trabajo Práctico Integrador

**Maestrando:** Bravo, Juan José  
**Año:** 2024

## Contenido

1. Análisis exploratorio de Datos
2. Estimación por MCO de un modelo de regresión lineal
3. Normalidad de los Residuos
4. Multicolinealidad
5. Heterocedasticidad
6. Conclusiones

## Análisis exploratorio de Datos

Realizamos un análisis exploratorio para conocer nuestro conjunto de datos y verificar, por ejemplo, cómo se comportan algunas categorías, de qué tipo son, etc. En el conjunto de datos no se encuentran datos faltantes.

Con el valor obtenido de la asimetría podemos observar que, al ser positivo, la cola va hacia la derecha, indicando que estos datos se encuentran sesgados positivamente. Esto sugiere que hay algunos autos con precios muy altos.

## Estimación por MCO de un modelo de regresión lineal

Con este modelo se pueden observar algunos puntos a tener en cuenta:
- El precio de los autos que usan gasolina es, en promedio, $1573.83 menor que los autos con otro tipo de combustible.
- Hardtop (-1864.31) y hatchback (-4863.87) muestran una relación negativa con el precio.
- Sedan (-3467.41) y wagon (-5290.87) también muestran una disminución en el precio.
- Enginesize (68.92, p < 0.001): Cada incremento de una unidad en el tamaño del motor aumenta el precio del auto en $68.92.
- Horsepower (59.80, p < 0.001): Cada incremento de una unidad en la potencia del motor incrementa el precio del auto en $59.80.
- Curbweight (4.19, p < 0.001): Un mayor peso del auto tiene un pequeño pero significativo efecto positivo en el precio.

## Normalidad de los Residuos

El p-value es 0.0004602, menor que el umbral de 0.05, lo que significa que rechazamos la hipótesis nula (H₀) y concluimos que los residuos no siguen una distribución normal.

## Multicolinealidad

La matriz obtenida identifica los siguientes puntos:
- Enginesize y horsepower: Correlación de 0.81.
- Enginesize y curbweight: Correlación de 0.85.
- Horsepower y curbweight: Correlación de 0.75.

## Heterocedasticidad

### Prueba de White:
- Estadístico BP: 49.309
- Grados de libertad (df): 2
- Valor p: 1.962e-11

### Prueba de Park:
Los residuales muestran valores que varían entre -8.5678 y 4.1763, sugiriendo una dispersión considerable en los residuos.

## Conclusiones

- **Multicolinealidad**: Algunas variables están muy relacionadas entre sí, lo que puede dificultar entender el impacto de cada variable en el precio de los autos.
- **Heterocedasticidad**: Los errores en nuestras predicciones no son constantes, lo que puede hacer que los resultados no sean del todo confiables.
- **Ajuste del Modelo**: El modelo no explica bien la variabilidad en los precios de los autos, indicando que faltan factores importantes.
- **Significancia de Variables**: Muchas variables no mostraron un efecto claro en el modelo, sugiriendo que algunas pueden no ser relevantes.

Pasos a seguir:
1. Revisar las variables y considerar incorporar otras que afecten la varianza.
2. Probar otros modelos.
3. Aplicar transformaciones necesarias para evitar complicaciones con variables fuertemente correlacionadas.

