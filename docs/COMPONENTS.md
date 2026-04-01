# Component Reference Catalog

This document lists every supported component type, its JSON `type` key, accepted `props`, and whether it supports `children`.

---

## Core Layout (12)

| Type | Children | Key Props |
|------|----------|-----------|
| `column` | yes | `mainAxisAlignment`, `crossAxisAlignment`, `padding` |
| `row` | yes | `mainAxisAlignment`, `crossAxisAlignment`, `padding` |
| `container` | yes | `padding`, `decoration`, `backgroundColor`, `width`, `height` |
| `card` | yes | `padding`, `elevation` |
| `listView` | yes | `padding` |
| `stack` | yes | `alignment`, `fit` |
| `positioned` | yes (1) | `top`, `bottom`, `left`, `right` |
| `wrap` | yes | `spacing`, `runSpacing`, `alignment`, `padding` |
| `spacer` | no | `height`, `width` |
| `responsive` | yes | breakpoint-specific children |
| `expanded` | yes (1) | `flex` |
| `flexible` | yes (1) | `flex`, `fit` |

---

## Layout Wrappers (22)

| Type | Children | Key Props |
|------|----------|-----------|
| `center` | yes (1) | `widthFactor`, `heightFactor` |
| `align` | yes (1) | `alignment` |
| `padding` | yes (1) | `padding` |
| `sizedBox` | yes (1) | `width`, `height` |
| `constrainedBox` | yes (1) | `constraints` (`minWidth`, `maxWidth`, `minHeight`, `maxHeight`) |
| `fittedBox` | yes (1) | `fit`, `alignment` |
| `fractionallySizedBox` | yes (1) | `widthFactor`, `heightFactor`, `alignment` |
| `intrinsicHeight` | yes (1) | — |
| `intrinsicWidth` | yes (1) | — |
| `limitedBox` | yes (1) | `maxWidth`, `maxHeight` |
| `overflowBox` | yes (1) | `maxWidth`, `maxHeight`, `alignment` |
| `aspectRatio` | yes (1) | `aspectRatio` |
| `baseline` | yes (1) | `baseline`, `baselineType` |
| `opacity` | yes (1) | `opacity` (0.0–1.0) |
| `clipRRect` | yes (1) | `borderRadius` |
| `clipOval` | yes (1) | — |
| `safeArea` | yes (1) | `top`, `bottom`, `left`, `right` |
| `rotatedBox` | yes (1) | `quarterTurns` |
| `ignorePointer` | yes (1) | `ignoring` |
| `absorbPointer` | yes (1) | `absorbing` |
| `offstage` | yes (1) | `offstage` |
| `visibility` | yes (1) | `visible` |

---

## Decorators (7)

| Type | Children | Key Props |
|------|----------|-----------|
| `material` | yes (1) | `elevation`, `color`, `borderRadius`, `type` |
| `hero` | yes (1) | `tag` |
| `decoratedBox` | yes (1) | `decoration` (BoxDecoration object) |
| `indexedStack` | yes | `index` |
| `transform` | yes (1) | `transformType` (`rotate`/`scale`/`translate`), `angle`, `scale`, `offsetX`, `offsetY` |
| `backdropFilter` | yes (1) | `sigmaX`, `sigmaY` |
| `banner` | yes (1) | `message`, `location` (`topStart`/`topEnd`/`bottomStart`/`bottomEnd`), `color` |

---

## Scrollables (6)

| Type | Children | Key Props |
|------|----------|-----------|
| `scrollView` | yes | `direction`, `reverse`, `padding`, `physics` |
| `gridView` | yes | `crossAxisCount`, `crossAxisSpacing`, `mainAxisSpacing`, `childAspectRatio`, `padding` |
| `pageView` | yes | `height`, `scrollDirection`, `pageSnapping`, `physics` |
| `customScrollView` | yes | `physics` |
| `sliverList` | yes | — |
| `sliverGrid` | yes | `crossAxisCount`, `crossAxisSpacing`, `mainAxisSpacing`, `childAspectRatio` |

---

## Interactives (6)

| Type | Children | Key Props |
|------|----------|-----------|
| `inkWell` | yes (1) | `borderRadius`, `splashColor`, `highlightColor` + `action` |
| `gestureDetector` | yes (1) | + `action` |
| `tooltip` | yes (1) | `message` |
| `dismissible` | yes (1) | `id` (used as Key), `direction` |
| `draggable` | yes (1) | `axis`, `feedbackScale` |
| `longPressDraggable` | yes (1) | `axis`, `feedbackScale` |

---

## Animated (9)

All animated types accept `duration` (ms) and `curve`.

| Type | Children | Extra Props |
|------|----------|-------------|
| `animatedContainer` | yes (1) | `width`, `height`, `padding`, `decoration`, `alignment` |
| `animatedOpacity` | yes (1) | `opacity` |
| `animatedCrossFade` | yes (2) | `showFirst` |
| `animatedSwitcher` | yes (1) | — |
| `animatedAlign` | yes (1) | `alignment` |
| `animatedPadding` | yes (1) | `padding` |
| `animatedPositioned` | yes (1) | `top`, `bottom`, `left`, `right`, `width`, `height` |
| `animatedSize` | yes (1) | `alignment` |
| `animatedScale` | yes (1) | `scale`, `alignment` |

---

## Tiles (5)

| Type | Children | Key Props |
|------|----------|-----------|
| `listTile` | no | `title`, `subtitle`, `leadingIcon`, `trailingIcon` |
| `expansionTile` | yes | `title`, `subtitle`, `leadingIcon`, `initiallyExpanded` |
| `switchListTile` | no | `id`, `title`, `subtitle`, `value` |
| `checkboxListTile` | no | `id`, `title`, `subtitle`, `value` |
| `radioListTile` | no | `id`, `title`, `subtitle`, `value`, `groupValue` |

---

## Tables (4)

| Type | Children | Key Props |
|------|----------|-----------|
| `table` | yes (`tableRow`) | `border`, `defaultVerticalAlignment`, `columnWidths` |
| `tableRow` | yes | — |
| `tableCell` | yes (1) | `verticalAlignment` |
| `dataTable` | no | `columns` (array), `rows` (array with `cells`) |

---

## Text Variants (3)

| Type | Children | Key Props |
|------|----------|-----------|
| `selectableText` | no | `content`, `style`, `textAlign`, `maxLines` |
| `richText` | no | `spans` (array: `text`, `color`, `fontSize`, `fontWeight`, `fontStyle`, `decoration`) |
| `defaultTextStyle` | yes | `style` |

---

## Button Variants (5)

| Type | Children | Key Props |
|------|----------|-----------|
| `textButton` | no | `label`, `icon`, `color` + `action` |
| `outlinedButton` | no | `label`, `icon`, `color`, `borderColor` + `action` |
| `iconButton` | no | `icon`, `tooltip`, `size`, `color` + `action` |
| `floatingActionButton` | no | `icon`, `label` (extended), `backgroundColor` + `action` |
| `segmentedButton` | no | `segments` (array: `value`, `label`, `icon`), `selected` |

---

## Media & Display (7)

| Type | Children | Key Props |
|------|----------|-----------|
| `placeholder` | no | `width`, `height`, `strokeWidth`, `color` |
| `circleAvatar` | no | `label`, `icon`, `imageUrl`, `radius`, `backgroundColor` |
| `verticalDivider` | no | `width`, `thickness`, `color`, `indent`, `endIndent` |
| `popupMenuButton` | no | `icon`, `items` (array: `value`, `label`, `icon`) + `action` |
| `searchBar` | no | `hintText`, `leadingIcon` |
| `searchAnchor` | no | `hintText`, `suggestions` (array) |
| `tooltip` | yes (1) | `message` |

---

## Leaf Components (10)

| Type | Children | Key Props |
|------|----------|-----------|
| `text` | no | `content`, `style` (`fontSize`, `fontWeight`, `color`, `textAlign`) |
| `button` | no | `label`, `style` (`backgroundColor`, `textColor`, `borderRadius`) + `action` |
| `image` | no | `url`, `width`, `height`, `fit`, `borderRadius` |
| `input` | no | `id`, `label`, `hint`, `maxLines`, `keyboardType`, `validation` |
| `divider` | no | `height`, `thickness`, `color`, `indent`, `endIndent` |
| `icon` | no | `name`, `size`, `color` |
| `chip` | no | `label`, `avatar`, `backgroundColor`, `textColor`, `outlined` |
| `progress` | no | `variant` (`linear`/`circular`), `value`, `color`, `strokeWidth` |
| `badge` | yes (1) | `label`, `backgroundColor`, `textColor`, `small` |
| `switch` / `checkbox` | no | `id`, `label`, `subtitle`, `value` |

---

## Interactive Inputs (3)

| Type | Children | Key Props |
|------|----------|-----------|
| `slider` | no | `id`, `value`, `min`, `max`, `divisions`, `label`, `activeColor` |
| `rangeSlider` | no | `id`, `startValue`, `endValue`, `min`, `max`, `divisions`, `activeColor` |
| `radio` | no | `id`, `value`, `groupValue`, `label`, `activeColor` |

---

## Action Types (7)

| Action | Required Fields | Description |
|--------|----------------|-------------|
| `navigate` | `targetScreenId` | Push a new screen |
| `goBack` | — | Pop current screen |
| `snackbar` | `message` | Show a snackbar |
| `submit` | — | Collect all input values |
| `copyToClipboard` | `message` | Copy text to clipboard |
| `openUrl` | `message` (URL) | Open URL in external browser |
| `showDialog` | `targetScreenId` (title), `message` (body) | Show an alert dialog |
