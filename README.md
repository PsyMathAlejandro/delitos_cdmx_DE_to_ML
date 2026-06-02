# 🔍 Pipeline de Incidencia Delictiva CDMX

Pipeline end-to-end de datos e inteligencia artificial sobre **582,362 registros de delitos en la Ciudad de México (2017-2019)**, construido con arquitectura Medallion en Databricks.

---

## 🏗️ Arquitectura

```
Bronze (datos crudos)
      ↓
Silver (limpieza y feature engineering) → PySpark
      ↓
Gold (agregaciones para ML)             → PySpark + dbt
      ↓
Modelo ML (Random Forest)               → Spark MLlib + MLflow
      ↓
Orquestación automática                 → Databricks Workflows
```

---

## 📦 Stack Tecnológico

- **PySpark** — ETL y transformaciones distribuidas
- **Delta Lake** — Almacenamiento en capas Bronze/Silver/Gold
- **Unity Catalog** — Gobernanza y catálogo de datos
- **Spark MLlib** — Entrenamiento del modelo de clasificación
- **MLflow** — Tracking de experimentos y Model Registry
- **dbt** — Transformaciones SQL en capa Gold
- **Databricks Workflows** — Orquestación automática mensual

---

## 📁 Estructura del Repositorio

```
delitos-cdmx-pipeline/
│
├── README.md
│
├── notebooks/
│   ├── 01_bronze_to_silver.ipynb      # ETL y limpieza
│   ├── 02_silver_to_gold.ipynb        # Feature engineering
│   └── 03_prediction_model.ipynb      # Modelo ML y simulador
│
├── dbt/
│   └── delitos_cdmx/
│       ├── dbt_project.yml
│       ├── profiles.yml.example       # Sin credenciales reales
│       └── models/
│           ├── sources.yml
│           ├── silver_base.sql
│           └── gold_features.sql
│
├── workflows/
│   └── pipeline_delitos_cdmx.json     # Definición del workflow
│
└── data/
    └── sample_delitos.csv             # Muestra de 1,000 registros
```

---

## 🔧 ETL — Bronze a Silver

- Filtrado de 16 alcaldías válidas de CDMX
- Tratamiento de valores nulos y strings `"NA"`
- Estandarización de nombres de alcaldías
- Casteo y validación de columnas temporales
- Extracción de features: `hora_del_dia`, `dia_semana`, `trimestre`
- Cálculo de `dias_para_registro` como feature de contexto institucional
- Filtro de registros 2017 en adelante

**Resultado:** 582,362 registros limpios desde 808,871 originales

---

## ⚙️ Feature Engineering — Silver a Gold

Window functions para agregar contexto histórico por alcaldía:

| Feature | Descripción |
|---|---|
| `conteo_alcaldia_hora` | Actividad histórica por alcaldía y hora |
| `conteo_alcaldia_dia` | Actividad histórica por alcaldía y día de semana |
| `conteo_alcaldia_mes` | Estacionalidad mensual por alcaldía |

---

## 🤖 Modelo de Clasificación

**Problema:** Predecir la alcaldía con mayor riesgo dado hora, día y tipo de delito.

| Parámetro | Valor |
|---|---|
| Algoritmo | Random Forest |
| Árboles | 50 |
| Profundidad máxima | 8 |
| Manejo de desbalance | Class weights |
| **Accuracy** | **97.94%** |
| **F1 Score** | **0.98** |
| Overfitting | Ninguno (train = test) |

---

## 🚔 Aplicación Real: Simulador de Patrullaje

Dado un día y hora, el simulador genera un **ranking de alcaldías por nivel de riesgo** — una aplicación directa para optimización de recursos policiales.

```python
simular_patrullaje(dia_semana=5, hora=23)  # viernes a las 11pm

# Output:
# COYOACAN         → Prioridad 3
# TLALPAN          → Prioridad 3
# TLAHUAC          → Prioridad 2
# IZTAPALAPA       → Prioridad 2
```

---

## ⚙️ Orquestación

Pipeline automatizado con **Databricks Workflows** — se ejecuta mensualmente:

```
01_bronze_to_silver → 02_silver_to_gold → 03_prediction_model
```

---

## 📊 Dataset

Fuente: **Fiscalía General de Justicia de la Ciudad de México**  
Descarga: [datos.cdmx.gob.mx](https://datos.cdmx.gob.mx/dataset/carpetas-de-investigacion-fgj)

---

## 🚀 Cómo Reproducirlo

1. Clona el repositorio
```bash
git clone https://github.com/PsyMathAlejandro/delitos_cdmx_DE_to_ML
```

2. Descarga el dataset de la fuente oficial y cárgalo en Databricks como tabla Bronze

3. Configura las credenciales de dbt:
```bash
cp dbt/delitos_cdmx/profiles.yml.example dbt/delitos_cdmx/profiles.yml
# Edita profiles.yml con tus credenciales
```

4. Ejecuta los notebooks en orden o configura el Workflow en Databricks

---

## 👤 Autor

**Alejandro** — Ingeniero de Datos  
[LinkedIn](https://www.linkedin.com/in/gabriel-alejandro-herrera-gandarela-2b6412220/?skipRedirect=true)
