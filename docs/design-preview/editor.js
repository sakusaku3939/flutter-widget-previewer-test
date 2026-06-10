const tokenInputs = Array.from(document.querySelectorAll("[data-token]"));
const tokenOutput = document.querySelector("[data-token-output]");
const resetButton = document.querySelector("[data-reset]");
const copyButton = document.querySelector("[data-copy]");
const deviceFrame = document.querySelector(".device-frame");
const viewportButtons = Array.from(document.querySelectorAll("[data-viewport-button]"));

const cssVariableMap = {
  "color.primary": "--color-primary",
  "color.background": "--color-background",
  "color.surface": "--color-surface",
  "color.text": "--color-text",
  "color.success": "--color-success",
  "color.error": "--color-error",
  "typography.baseFontSize": "--typography-base-font-size",
  "typography.headingScale": "--typography-heading-scale",
  "spacing.base": "--spacing-base",
  "radius.card": "--radius-card",
  "component.buttonRadius": "--component-button-radius",
  "component.cardPadding": "--component-card-padding",
  "component.headingWeight": "--component-heading-weight",
  "shadow.elevation": "--shadow-elevation"
};

const initialValues = tokenInputs.reduce((values, input) => {
  values[input.dataset.token] = input.value;
  return values;
}, {});

function setNestedValue(target, path, value) {
  const segments = path.split(".");
  const last = segments.pop();
  const parent = segments.reduce((current, segment) => {
    current[segment] = current[segment] || {};
    return current[segment];
  }, target);
  parent[last] = value;
}

function formatValue(input) {
  const unit = input.dataset.unit || "";
  return `${input.value}${unit}`;
}

function buildTokens() {
  const tokens = {};

  tokenInputs.forEach((input) => {
    setNestedValue(tokens, input.dataset.token, formatValue(input));
  });

  tokens.color.warning = "#b45309";
  tokens.color.muted = "#64748b";

  tokens.component.card = {
    background: tokens.color.surface,
    padding: tokens.component.cardPadding,
    radius: tokens.radius.card,
    shadow: `${tokens.shadow.elevation} soft elevation`
  };

  tokens.component.button = {
    background: tokens.color.primary,
    radius: tokens.component.buttonRadius,
    foreground: "#ffffff",
    minTouchTarget: "48dp"
  };

  tokens.component.heading = {
    weight: tokens.component.headingWeight,
    scale: tokens.typography.headingScale
  };

  return tokens;
}

function applyTokens() {
  tokenInputs.forEach((input) => {
    const cssVariable = cssVariableMap[input.dataset.token];
    if (cssVariable) {
      document.documentElement.style.setProperty(cssVariable, formatValue(input));
    }

    const output = input.parentElement.querySelector("output");
    if (output) {
      output.textContent = formatValue(input);
    }
  });

  tokenOutput.textContent = JSON.stringify(buildTokens(), null, 2);
}

function resetTokens() {
  tokenInputs.forEach((input) => {
    input.value = initialValues[input.dataset.token];
  });
  applyTokens();
}

async function copyTokens() {
  const tokens = JSON.stringify(buildTokens(), null, 2);

  if (navigator.clipboard && window.isSecureContext) {
    await navigator.clipboard.writeText(tokens);
    copyButton.textContent = "Copied";
  } else {
    const textarea = document.createElement("textarea");
    textarea.value = tokens;
    textarea.setAttribute("readonly", "");
    textarea.style.position = "fixed";
    textarea.style.inset = "0 auto auto 0";
    textarea.style.opacity = "0";
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand("copy");
    textarea.remove();
    copyButton.textContent = "Copied";
  }

  window.setTimeout(() => {
    copyButton.textContent = "Copy";
  }, 1200);
}

function setViewport(viewport) {
  deviceFrame.dataset.viewport = viewport;
  viewportButtons.forEach((button) => {
    button.setAttribute("aria-pressed", String(button.dataset.viewportButton === viewport));
  });
}

tokenInputs.forEach((input) => {
  input.addEventListener("input", applyTokens);
});

viewportButtons.forEach((button) => {
  button.addEventListener("click", () => setViewport(button.dataset.viewportButton));
});

resetButton.addEventListener("click", resetTokens);
copyButton.addEventListener("click", copyTokens);

applyTokens();
