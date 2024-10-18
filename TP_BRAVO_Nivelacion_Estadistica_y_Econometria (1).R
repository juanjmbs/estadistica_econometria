install.packages("dplyr")
install.packages("ggplot2")
install.packages("moments")
install.packages("tidyverse")
install.packages("corrr")
install.packages("knitr")
install.packages("kableExtra")
install.packages("GGally")
install.packages("readxl")
install.packages("tidymodels")
install.packages("KbMvtSkew")
install.packages("lmtest")
install.packages("psych")
library(dplyr)
library(psych)
library(ggplot2)
library(moments)
library(tidyverse)
library(corrr)
library(knitr)
library(kableExtra)
library(GGally)
library(readxl)
library(tidymodels)
library(KbMvtSkew)
library(lmtest)


#Importamos el conjunto de datos
df <- read.csv("C:/Users/juanj/OneDrive/Escritorio/CarPrice_Assignment.csv", sep=",")
df

str(df)

dim(df)

total_faltantes <- sum(is.na(df))
print(total_faltantes)

ggplot(df, aes(x = price)) +
  geom_histogram(bins = 30, fill = "lightblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribución de Price", x = "Precio", y = "Frecuencia")

ggplot(df, aes(x = price, y = fueltype)) +
  geom_bar(stat = "identity") +
  labs(title = "Frecuencia por Categoría",
       x = "Categoría",
       y = "Frecuencia") +
  theme_minimal()

##1) ANÁLISIS EDA-----------------------------------------------------------------------------------
#Obtenemos una primera observacion de los datos
df %>% glimpse()

# Selecionamos la variable endogena (price) y 5 variables exógenas. Una de ellas es categórica
df_selected <- df %>%
  select(price, fueltype, carbody, enginesize, horsepower, curbweight)

# Visualizar el nuevo dataframe
head(df_selected)

#Ordenamos el conjunto de datos mediante las variables price y carbody
df_selected_o <-   df_selected %>% arrange(price, carbody)
df_selected_o

df_selected_o %>% summary()

# Armamos histograma 
ggplot(df_selected_o, aes(x = price, fill = carbody)) +
  geom_histogram(binwidth = 1000, alpha = 0.7, position = "identity") +
  labs(title = "Distribución de precios por tipo de carrocería", 
       x = "Precio", 
       y = "Frecuencia") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set1")


asimetria_charges <- skewness(df_selected_o$price)
asimetria_charges

kurtosis_charges <- kurtosis(df_selected_o$price)
kurtosis_charges

##Identificamos los outliers
boxplot(df_selected_o$price, main = "Boxplot de Precios", ylab = "Precio")

# Calculamos los cuartiles
Q1 <- quantile(df_selected_o$price, 0.25)
Q3 <- quantile(df_selected_o$price, 0.75)

# Calculamos el rango intercuartílico (IQR)
IQR_value <- IQR(df_selected_o$price)

# Definimos límites para identificar outliers
lower_bound <- Q1 - 1.5 * IQR_value
upper_bound <- Q3 + 1.5 * IQR_value

# Identificamos outliers
outliers <- df_selected_o$price < lower_bound | df_selected_o$price > upper_bound

# Mostramos los límites
print(paste("Límite inferior:", lower_bound))
print(paste("Límite superior:", upper_bound))

# Reemplazamos los outliers con el límite inferior y superior
df_selected_o$price[df_selected_o$price < lower_bound] <- lower_bound
df_selected_o$price[df_selected_o$price > upper_bound] <- upper_bound


##VOLVEMOS A RE-EVALUAR EL MODELO
asimetria_charges <- skewness(df_selected_o$price)
asimetria_charges

kurtosis_charges <- kurtosis(df_selected_o$price)
kurtosis_charges


##ANÁLISIS MULTIVARIADO: CORRELACIÓN DE VARIABLES. 

numeric_vars <- df_selected_o %>% select_if(is.numeric)

# Calcular la matriz de correlación
cor_matrix <- cor(numeric_vars)

# Visualizar la matriz de correlación
print(cor_matrix)

# visualizamos con heatmap
heatmap(cor_matrix, main = "Heatmap de la Correlación", symm = TRUE)

# Boxplot para visualizar la relación entre carbody y price
ggplot(df_selected_o, aes(x = carbody, y = price)) +
  geom_boxplot() +
  ggtitle("Boxplot de Carbody vs Price") +
  xlab("Carbody") +
  ylab("Price")


##2) ESTIMACIÓN POR MCO DE UN MODELO DE REGRESIÓN LINEAL--------------------------------------------
df_selected_o$carbody <- as.factor(df_selected_o$carbody)
df_selected_o$fueltype <- as.factor(df_selected_o$fueltype)

# Ajustar el modelo de regresión lineal
modelo_mco <- lm(price ~ fueltype + carbody + enginesize + horsepower + curbweight, data = df_selected)

# Mostrar un resumen del modelo
summary(modelo_mco)


##3) NORMALIDAD DE LOS RESIDUOS----------------------------------------------------------------------
residuos <- residuals(modelo_mco)

hist(residuos, breaks = 20, main = "Histograma de los Residuos", xlab = "Residuos")

qqnorm(residuos)
qqline(residuos, col = "red")

shapiro.test(residuos)

##4) MULTICOLINEALIDAD---------------------------------------------------------------------------------
#1 enfoque

cor_matrix <- cor(df_selected_o[c("enginesize", "horsepower", "curbweight")])
print(cor_matrix)

#2 enfoque

df_selected <- read.csv("C:/Users/juanj/OneDrive/Escritorio/CarPrice_Assignment.csv", sep=',')

# Obtenemos info del dataset
glimpse(df_selected)


# Ajustamos un modelo múltiple con las variables seleccionadas
modelo_full <- lm(price ~ enginesize + horsepower + curbweight + fueltype + carbody, data = df_selected)

# Resumen del modelo
summary(modelo_full)

# Evaluación de multicolinealidad usando VIF
install.packages("car")
library(car)  # Asegúrate de que el paquete car esté instalado

vif_values <- vif(modelo_full)
print(vif_values)

# Verificamos qué variables tienen un VIF alto (generalmente > 5 o 10)
high_vif <- vif_values[vif_values > 5]
print(high_vif)

##5) Heterocedasticidad-------------------------------------------------------------------------------

# Prueba de White
white_test <- bptest(modelo_full, ~ fitted(modelo_full) + I(fitted(modelo_full)^2))
print(white_test)

# Prueba de Park
residuos <- resid(modelo_full)

# Ajustamos un modelo de regresión con log(residuos^2)
modelo_park <- lm(log(residuos^2) ~ enginesize + horsepower + curbweight + fueltype + carbody, data = df_selected)

# Resumen del modelo de Park
summary(modelo_park)

