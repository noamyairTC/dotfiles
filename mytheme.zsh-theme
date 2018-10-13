# local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT='%{$fg[white]%}%n@%{$fg[green]%}%m%{$reset_color%} ${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

# PROMPT='%{$fg[blue]%}%n%{$reset_color%} on %{$fg[red]%}%M%{$reset_color%} in %{$fg[blue]%}%~%b%{$reset_color%}$(git_time_since_commit)$(check_git_prompt_info)
# $ '

PROMPT='
%(?..$fg_bold[red]✗ exit code: $?

)$fg_bold[green]➜  $fg_bold[cyan]%n$fg_bold[white]@$fg_bold[blue]%m$fg_bold[white]:$fg_bold[green]%5~$reset_color$(git_prompt_info)$(virtualenv_prompt_info2)$(vimode_prompt_info)
\$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" $fg_bold[white]on %{$fg_bold[yellow]%}⎇  "
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_VIRTUALENV_PROMPT_PREFIX=" $fg_bold[white]using $fg_bold[cyan]"
ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX="$reset_color"

ZSH_THEME_VIMODE_PROMPT_PREFIX=" $fg_bold[black]$bg[yellow] "
ZSH_THEME_VIMODE_PROMPT_SUFFIX=" $reset_color"
ZSH_THEME_VIMODE_PROMPT_NORMAL="NORMAL MODE"
ZSH_THEME_VIMODE_PROMPT_INSERT="INSERT MODE"

function virtualenv_prompt_info2() {
    if [ ! -z "$VIRTUAL_ENV" ]; then
        local virtual_env_name="$(basename $VIRTUAL_ENV)"
        echo $ZSH_THEME_VIRTUALENV_PROMPT_PREFIX$virtual_env_name$ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX
    else
        echo ""
    fi
}

function vimode_prompt_info() {
    case "$VIMODE" in
        normal)
            echo $ZSH_THEME_VIMODE_PROMPT_PREFIX$ZSH_THEME_VIMODE_PROMPT_NORMAL$ZSH_THEME_VIMODE_PROMPT_SUFFIX
            ;;
        # insert)
        #     echo $ZSH_THEME_VIMODE_PROMPT_PREFIX$ZSH_THEME_VIMODE_PROMPT_INSERT$ZSH_THEME_VIMODE_PROMPT_SUFFIX
        #     ;;
        *)
            echo ""
    esac
}
