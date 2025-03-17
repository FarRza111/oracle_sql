import pymc3 as pm
import pandas as pd
import numpy as np
import arviz as az
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

# Simulated dataset (replace with real data)
np.random.seed(42)
n = 100  # Number of observations

# Simulated marketing spend (in $1000s)
tv_ads = np.random.uniform(50, 200, n)
digital_ads = np.random.uniform(20, 100, n)
social_media = np.random.uniform(10, 80, n)
price_discount = np.random.uniform(0, 30, n)  # % discount
seasonality = np.sin(np.linspace(0, 3.14 * 2, n))  # Seasonality effect
oil_prices = np.random.uniform(50, 100, n)  # External factor affecting flights

# Generate ticket sales (dependent variable)
sales = (
    5 + 0.3 * tv_ads + 0.4 * digital_ads + 0.2 * social_media
    - 0.1 * price_discount + 0.5 * seasonality - 0.2 * oil_prices
    + np.random.normal(0, 5, n)
)

# Create DataFrame
df = pd.DataFrame({
    'tv_ads': tv_ads,
    'digital_ads': digital_ads,
    'social_media': social_media,
    'price_discount': price_discount,
    'seasonality': seasonality,
    'oil_prices': oil_prices,
    'sales': sales
})

# Standardize Data
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df.drop(columns=['sales']))
y_scaled = scaler.fit_transform(df[['sales']])

# Bayesian Regression Model
with pm.Model() as model:
    # Priors for regression coefficients
    beta_tv = pm.Normal("beta_tv", mu=0, sigma=1)
    beta_digital = pm.Normal("beta_digital", mu=0, sigma=1)
    beta_social = pm.Normal("beta_social", mu=0, sigma=1)
    beta_discount = pm.Normal("beta_discount", mu=0, sigma=1)
    beta_season = pm.Normal("beta_season", mu=0, sigma=1)
    beta_oil = pm.Normal("beta_oil", mu=0, sigma=1)
    intercept = pm.Normal("intercept", mu=0, sigma=1)

    # Linear model
    mu = (
        intercept
        + beta_tv * X_scaled[:, 0]
        + beta_digital * X_scaled[:, 1]
        + beta_social * X_scaled[:, 2]
        + beta_discount * X_scaled[:, 3]
        + beta_season * X_scaled[:, 4]
        + beta_oil * X_scaled[:, 5]
    )

    # Likelihood (assuming normally distributed errors)
    sigma = pm.HalfNormal("sigma", sigma=1)
    y_obs = pm.Normal("y_obs", mu=mu, sigma=sigma, observed=y_scaled[:, 0])

    # Sampling
    trace = pm.sample(2000, return_inferencedata=True)

# Show results
az.plot_posterior(trace)
plt.show()
