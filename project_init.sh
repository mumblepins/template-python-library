#!/usr/bin/env bash
prun() {
    poetry run "$@"
}

TO_REPLACE_UNDER=template_python_library
TO_REPLACE_DASH=template-python-library
read -rp 'Enter new project name: ' project_name_dash
project_name_under=$(echo "$project_name_dash" | tr '-' '_')

echo "Renaming to $project_name_under / $project_name_dash"
grep -lr --exclude='project_init.sh' --exclude-dir='.git' "$TO_REPLACE_DASH" . \
    | tee >(cat 1>&2) \
    | xargs -I{} sed -i 's|'"$TO_REPLACE_DASH"'|'"$project_name_dash"'|g' {}
find . -iname '*'"$TO_REPLACE_DASH"'*' \
    | tee >(cat 1>&2) \
    | sed -E 's|(.*/?)+('"$TO_REPLACE_DASH"')(.*)$|\1\2\3 \1'"$project_name_dash"'\3|' \
    | xargs -r -n2 mv $1 $2
grep -lr --exclude='project_init.sh' --exclude-dir='.git' "$TO_REPLACE_UNDER" . \
    | tee >(cat 1>&2) \
    | xargs -I{} sed -i 's|'"$TO_REPLACE_UNDER"'|'"$project_name_under"'|g' {}
find . -iname '*'"$TO_REPLACE_UNDER"'*' \
    | tee >(cat 1>&2) \
    | sed -E 's|(.*/?)+('"$TO_REPLACE_UNDER"')(.*)$|\1\2\3 \1'"$project_name_under"'\3|' \
    | xargs -r -n2 mv $1 $2
grep -lr --exclude='project_init.sh' 'AUTHOR_NAME_AND_EMAIL' . \
    | xargs -I{} \
        sed -i 's|AUTHOR_NAME_AND_EMAIL|'"$(git config user.name) <$(git config user.email)>"'|g' {}

#git init
# poetry update
poetry install --sync
prun pre-commit install --install-hooks

prun pre-commit run --all-files --hook-stage manual
prun pre-commit run -a --hook-stage post-commit
